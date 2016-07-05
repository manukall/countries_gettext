defmodule CountriesGettext.GenerateFiles do
  @country_codes_input_json_path to_string(:code.priv_dir(:countries_gettext)) <> "/iso-codes/data/iso_3166-1.json"

  @codes_by_name @country_codes_input_json_path
  |> File.read!
  |> Poison.decode!
  |> Map.get("3166-1")
  |> Enum.map(fn %{"name" => name, "alpha_2" => code} -> {name, String.downcase(code)} end)
  |> Enum.into(%{})


  def generate_pot(output_dir) do
    content = @country_codes_input_json_path
    |> File.read!
    |> Poison.decode!
    |> Map.get("3166-1")
    |> Enum.map(&pot_entry_for_country/1)
    |> Enum.join("\n")

    File.write!(pot_path(output_dir), content)
  end


  def generate_po(output_dir, locale) do
    input = locale
    |> po_input_json_path
    |> File.read!

    content = Regex.replace(~r/msgid "([^"]+)"/, input, &replace_name_by_code/2)

    File.write!(po_path(output_dir, locale), content)
  end

  def replace_name_by_code(str, name) do
    case Map.fetch(@codes_by_name, name) do
      :error -> str
      {:ok, code} -> String.replace(str, name, code)
    end
  end

  def pot_entry_for_country(%{"alpha_2" => code, "name" => name}) do
    ~s"""
    msgid "#{String.downcase(code)}"
    msgstr "#{name}"
    """
  end

  defp pot_path(output_dir) do
    Path.join([output_dir, "countries.pot"])
  end


  defp po_path(output_dir, locale) do
    Path.join([output_dir, locale, "LC_MESSAGES", "countries.pot"])
  end

  def po_input_json_path(locale) do
    :code.priv_dir(:countries_gettext)
    |> to_string
    |> Path.join(Path.join(["iso-codes", "iso_3166-1", "#{locale}.po"]))
  end

end