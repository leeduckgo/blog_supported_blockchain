defmodule YcyUser do
  use Directive, :schema

  schema "ycy_users" do
    field(:puid, :string)
    field(:name, :string)
    field(:level, :integer)
    field(:balance, :integer)
    belongs_to(:ycy_group, YcyGroup)
  end

  def get_users() do
    Repo.all(YcyUser)
  end

  def get_users_by_group_puid(group_puid) do
    group_puid
    |> YcyGroup.get_group_by_id()
    |> Repo.preload(:ycy_users)
    |> Map.fetch!(:ycy_users)
  end

  def insert(users, group_id) do
    Enum.map(users, fn user ->
      user_modified =
        YcyUser
        |> StructTranslater.to_struct(user)
        |> Map.update(:ycy_group_id, group_id, &(&1 = group_id))
      if exist?(user_modified) do
        nil
      else
        Repo.insert(user_modified)
      end
    end)
  end

  def exist?(user) do
    get_user_by_puid(user.puid)
  end

  def get_user_by_puid(puid) do
    YcyUser
    |> where(puid: ^puid)
    |> Repo.one()
  end

  def get_balance(puid) do
    puid
    |> get_user_by_puid()
    |> Map.fetch!(:balance)
  end

  def transfer(from, to, amount) do
    user_from = get_user_by_puid(from)
    user_to = get_user_by_puid(to)
    do_transfer(user_from, user_to, amount)
  end

  defp do_transfer(%YcyUser{balance: balance}, _user_to, amount)
  when balance < amount do
    {:error, "insufficient_balance"}
  end

  defp do_transfer(%YcyUser{puid: puid_from}, %YcyUser{puid: puid_to} , _amount)
  when puid_from == puid_to do
    {:error, "transfer to self"}
  end
  defp do_transfer(%YcyUser{balance: balance_from} = user_from, %YcyUser{balance: balance_to} = user_to, amount) do
    user_from_transfered =
      user_from
      |> changeset(%{balance: balance_from - amount})
      |> Repo.update!()
    user_to_transfered =
      user_to
      |> changeset(%{balance: balance_to + amount})
      |> Repo.update!()
    {:ok,[user_from_transfered, user_to_transfered, amount]}
  end

  def changeset(ycy_user, params \\ %{}) do
    ycy_user
    |> cast(params, [
      :balance
    ])
  end
end
