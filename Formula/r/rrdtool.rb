class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.10.3/rrdtool-1.10.3.tar.gz"
  sha256 "843b7caa2a80a815d44ac5c65daa42920cb64586fe804e36d0bc0783554e0635"
  license "GPL-2.0-or-later" => { with: "RRDtool-FLOSS-exception-2.0" }

  bottle do
    sha256 arm64_tahoe:   "2a8aef977853e7377eff56723665f698641e386fd42b4c08620b5d35c1ea9afb"
    sha256 arm64_sequoia: "2b9c0214bfd612bf942910a87d008bf5a0a7d3e4aa7d3bf58700be10d2a68eec"
    sha256 arm64_sonoma:  "6f760c882a97390cea6d8e6afc59948bfd70620dfc93c164c51c20536bf2a90f"
    sha256 sonoma:        "d4ecdad71e024a6f06f21b2a21488be1d33d1c746449e51eda0af6c6f75fcbe7"
    sha256 arm64_linux:   "7c511d76234e3f72ff89482a2eff773bc192e6371283097e5269179bfdcb0855"
    sha256 x86_64_linux:  "cba6f2b5d2713d2f8cedf52a81ea8c58c1fc12ad71846d6eda908a06d8838b95"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libpng"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    args = %w[
      --disable-silent-rules
      --disable-lua
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-tcl
    ]

    system "./bootstrap" if build.head?
    inreplace "configure", /^sleep 1$/, "#sleep 1"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"

    system bin/"rrdtool", "dump", "temperature.rrd"
  end
end
