defmodule EbayCrud do
  @moduledoc """
  EbayCrud keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def token(), do: "v^1.1#i^1#f^0#I^3#r^0#p^3#t^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"

end
