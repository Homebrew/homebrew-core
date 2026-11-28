class Songrec < Formula
  desc "Unofficial Shazam client for Linux, written in Rust"
  homepage "https://songrec.fossplant.re/"
  url "https://github.com/marin-m/SongRec/archive/refs/tags/0.8.2.tar.gz"
  sha256 "167eed70b477b01180d388d5ff1c9d07b0e73e1af3568737b06aecacb5003745"
  license "GPL-3.0-or-later"
  head "https://github.com/marin-m/SongRec.git", branch: "main"

  depends_on "appstream" => :build
  depends_on "blueprint-compiler" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libadwaita"
  depends_on "librsvg"
  depends_on "libsoup"
  depends_on "pango"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pipewire"
    depends_on "pulseaudio"
  end

  deny_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    if OS.mac?
      # https://github.com/gettext-rs/gettext-rs/tree/master/gettext-sys#environment-variables
      ENV["GETTEXT_DIR"] = Formula["gettext"].prefix.to_s
    end

    if OS.linux?
      system "cargo", "install", *std_cargo_args
    else
      system "cargo", "install", "--no-default-features", *std_cargo_args(features: ["gui", "ffmpeg"])
    end
  end

  test do
    # SongRec is a GUI-first application
    cmd = "#{bin}/songrec --help"

    assert_match "Usage: ", shell_output(cmd)

    cmd = "#{bin}/songrec -V"

    assert_match "songrec " + version.to_s, shell_output(cmd)
  end
end
