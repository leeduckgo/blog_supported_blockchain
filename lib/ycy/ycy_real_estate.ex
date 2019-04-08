defmodule YcyRealEstate do
  use Directive, :schema
  alias Blog.Repo
  # ycy_realestate
  schema "ycy_real_estates" do
    field(:name, :string)
    field(:signature, :string)
    field(:price, :integer)
    belongs_to(:ycy_user, YcyUser)
    timestamps()
  end

  def get_real_estates() do
    Repo.all(YcyRealEstate)
  end

  def get_real_estate(name) do
    YcyRealEstate
    |> where(name: ^name)
    |> Repo.one()
  end

  def buy_estate(buyer, amount, name) do
    real_estate = get_real_estate(name)
    do_buy_estate(buyer, amount, real_estate)
  end

  def do_buy_estate(_buyer, amount, _real_estate) when amount<=0 do
    :illegal_amount
  end
  def do_buy_estate(_buyer, _amount, real_estate) when is_nil(real_estate) do
    :no_exist
  end
  def do_buy_estate(_buyer, amount, %{price: price}) when amount <= price do
    :low_offer
  end
  def do_buy_estate(%{balance: balance}, amount, _real_estate) when balance <= amount do
    IO.puts inspect(balance)
    IO.puts inspect(amount)
    :no_enough_money
  end
  def do_buy_estate(%{id: user_id, balance: balance} = user, amount, %{id: re_id} = real_estate) do
    user
    |> YcyUser.changeset(%{balance: balance - amount, ycy_real_estate_id: re_id})
    |> Repo.update!()

    real_estate
    |> changeset(%{price: amount, ycy_user_id: user_id})
    |> Repo.update!()

    :success
  end

  def modify(signature, name) do
    real_estate = get_real_estate(name)
    real_estate
    |> changeset(%{signature: signature})
    |> Repo.update!()

    :success
  end

  def changeset(real_estate, params \\ %{}) do
    real_estate
    |> cast(params, [
      :ycy_user_id,
      :price,
      :signature,
      :name
    ])
  end
end
