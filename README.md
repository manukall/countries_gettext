# CountriesGettext

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `countries_gettext` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:countries_gettext, "~> 0.1.0"}]
    end
    ```

  2. Ensure `countries_gettext` is started before your application:

    ```elixir
    def application do
      [applications: [:countries_gettext]]
    end
    ```


## To update the source data:
  `rm -rf priv/iso-codes`
  `git clone https://salsa.debian.org/iso-codes-team/iso-codes priv/iso-codes`
  `rm -rf priv/iso-codes/.git`
