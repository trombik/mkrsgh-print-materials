# `xkcd`

Scripts and files to create images of `xkcd` comics with QR code to the
original pages. Designed for physical display in photo frame.

## Usage

```console
> bundle install
> bundle exec ruby init.rb $ID
```

`$ID` is the number of the comic.

The ruby script fetches larger images than the original on the web page,
generates a QR code in `SVG` format, copy a template `GIMP` file, keeps all of
them under `$ID` sub-directory.
