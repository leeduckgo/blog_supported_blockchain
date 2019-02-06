defmodule User do
  @moduledoc """
  Chain schema.
  """
  use Directive, :schema

  schema "users" do
    field :name, :string
    field :email, :string
    field :mixin_uuid, :string
    field :password, :string
    field :password_hash, :string
    field :group_id, :integer
    has_many :articles, Article
  end


  def admin?(%User{id: 0}), do: true
  def admin?(_), do: false
  def get_user(id) do
    User
    |> where(id: ^id)
    |> Blog.Repo.one()
  end

  def insert_user(attrs) do
    %User{}
    |> registration_changeset(attrs)
    |> Repo.insert()
  end
  @doc """
  hash the password
  """
  def registration_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :password])
    |> validate_required([:name, :password])
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:password, min: 5, max: 10)
    |> unique_constraint(:name)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end

  def authenticate_user(name, given_password) do
    query = Ecto.Query.from(u in User, where: u.name == ^name)

    Repo.one(query)
    |> check_password(given_password)
  end

  def check_password(nil, _), do: {:error, "Incorrect username or password"}

  def check_password(user, given_password) do
    case Bcrypt.verify_pass(given_password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
  end

end
