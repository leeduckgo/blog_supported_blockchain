defmodule YcyUser do
  use Directive, :schema

  schema "ycy_users" do
    field(:puid, :string)
    field(:name, :string)
    field(:level, :integer)
    field(:balance, :integer)
    belongs_to(:ycy_group, YcyGroup)
    belongs_to(:ycy_real_estate, YcyRealEstate)
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

      if exist?(user_modified, group_id) do
        nil
      else
        Repo.insert(user_modified)
      end
    end)
  end

  def exist?(user, group_id) do
    get_user_by_puid(user.puid, group_id)
  end

  def get_user_by_puid(puid, group_id) do
    group = YcyGroup.get_group_by_id(group_id)

    YcyUser
    |> where([u], u.puid == ^puid and u.ycy_group_id == ^group.id)
    |> Repo.one()
  end

  def get_balance(puid, group_id) do
    puid
    |> get_user_by_puid(group_id)
    |> Map.fetch!(:balance)
  end

  def transfer(from, to, amount, group_id) do
    user_from = get_user_by_puid(from, group_id)
    user_to = get_user_by_puid(to, group_id)
    do_transfer(user_from, user_to, amount)
  end

  defp do_transfer(_user_from, _user_to, amount) when amount <= 0 do
    {:error, "negative_amount"}
  end

  defp do_transfer(%YcyUser{balance: balance}, _user_to, amount)
       when balance < amount do
    {:error, "insufficient_balance"}
  end

  defp do_transfer(%YcyUser{puid: puid_from}, %YcyUser{puid: puid_to}, _amount)
       when puid_from == puid_to do
    {:error, "transfer to self"}
  end

  defp do_transfer(
         %YcyUser{balance: balance_from} = user_from,
         %YcyUser{balance: balance_to} = user_to,
         amount
       ) do
    user_from_transfered =
      user_from
      |> changeset(%{balance: balance_from - amount})
      |> Repo.update!()

    user_to_transfered =
      user_to
      |> changeset(%{balance: balance_to + amount})
      |> Repo.update!()

    {:ok, [user_from_transfered, user_to_transfered, amount]}
  end

  def changeset(ycy_user, params \\ %{}) do
    ycy_user
    |> cast(params, [
      :balance,
      :ycy_real_estate_id
    ])
  end
end
