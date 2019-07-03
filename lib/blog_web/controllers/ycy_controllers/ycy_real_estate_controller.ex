defmodule BlogWeb.YcyRealEstateController do
  use BlogWeb, :controller
  alias Blog.Repo

  def show(conn, %{"name" => name}) do
    try do
      real_estate =
        name
        |> YcyRealEstate.get_real_estate()
        |> StructTranslater.struct_to_map()

      json(conn, real_estate)
    rescue
      _ ->
        json(conn, %{"error" => "no_exist"})
    end
  end

  def show(conn, _params) do
    real_estates = YcyRealEstate.get_real_estates()

    real_estates_map =
      Enum.map(real_estates, fn real_estate ->
        real_estate_preloaded = Repo.preload(real_estate, :ycy_user)

        real_estate
        |> Map.put(:owner, real_estate_preloaded.ycy_user.name)
        |> StructTranslater.struct_to_map()
      end)

    json(conn, real_estates_map)
  end

  def buy(conn, %{
        "api" => api_key,
        "name" => name,
        "buyer" => buyer_puid,
        "group_id" => group_puid,
        "amount" => amount
      }) do
    if Auth.auth?(api_key) do
      real_estate = YcyRealEstate.get_real_estate(name)
      buyer = YcyUser.get_user_by_puid(buyer_puid, group_puid)
      IO.puts(inspect(buyer))

      result =
        if is_nil(real_estate) or is_nil(buyer) do
          :no_exist
        else
          YcyRealEstate.buy_estate(buyer, amount, name)
        end

      handle_result(conn, result)
    else
      json(conn, %{"result" => "error", "reason" => "no_auth"})
    end
  end

  def handle_result(conn, :success) do
    json(conn, %{"result" => "success"})
  end

  def handle_result(conn, error) do
    json(conn, %{"result" => "error", "reason" => error})
  end

  def update(conn, %{
        "api" => api_key,
        "user" => user_puid,
        "group_id" => group_puid,
        "name" => name,
        "signature" => signature
      }) do
    if Auth.auth?(api_key) do
      real_estate =
        name
        |> YcyRealEstate.get_real_estate()
        |> Repo.preload(:ycy_user)

      user = YcyUser.get_user_by_puid(user_puid, group_puid)

      if real_estate.ycy_user == user do
        YcyRealEstate.modify(signature, name)
        json(conn, %{"result" => "success"})
      else
        json(conn, %{"result" => "error", "reason" => "not_owner"})
      end
    else
      json(conn, %{"result" => "error", "reason" => "no_auth"})
    end
  end
end
