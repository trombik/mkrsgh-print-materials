## Requirements

- `inkscape`
- `ruby` and `bundler`

```console
bundle install
```

## Usage

```console
env WIFI_PASSWORD="password" bundle exec ruby wifiqr.rb
```

The output is saved to `output.svg`. The `inkscape` file is `qrcode.svg`.
