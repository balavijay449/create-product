defmodule EbayCrud.Repo do
  use Ecto.Repo,
    otp_app: :ebay_crud,
    adapter: Ecto.Adapters.Postgres
end
