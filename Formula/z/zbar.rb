class Zbar < Formula
  desc "Suite of barcodes-reading tools"
  homepage "https://linuxtv.org/downloads/zbar/"
  url "https://linuxtv.org/downloads/zbar/zbar-0.23.95.tar.gz"
  sha256 "7b0907a3114503e0a8fbd1c6bfdb61592e6ded79f68716d7ca673ddeb6a87e99"
  license "LGPL-2.1-only"
  compatibility_version 1
  head "https://github.com/mchehab/zbar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?zbar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "132f6bdf33f253a14d4d49e44105a53169559aaebdc10025c158eefcb78f713a"
    sha256 arm64_tahoe:       "9e4d77a11224eb74d0f3d8cbce1d4ecebe060530a8d93f42b4e33675d18a12c1"
    sha256 arm64_sequoia:     "a98b49716c7fa998cf58003f1cd31fd7d1a8345cf8bf8f9958fdce10e56cfcbe"
    sha256 arm64_linux:       "562b4bcff0f99072f99fc88c0d49784c6fe49f2178d40c171ae563f0ba260bce"
    sha256 x86_64_linux:      "34596c45dc26eb4cae6e6d50e6f8ebf8eb8e7292cc8619b0b6274a075495904b"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build

  depends_on "imagemagick"
  depends_on "jpeg-turbo"

  uses_from_macos "python"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "libtool"
    depends_on "little-cms2"
  end

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def install
    args = %w[
      -Dvideo=false
      -Djava=disabled
      -Dqt=false
      -Dgtk=no
      -Dx11=disabled
    ]

    # zbar uses gettext but upstream only links libintl on Windows, and the
    # newer macOS linker no longer resolves it transitively. Link it explicitly.
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "examples/qr-code.png"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zbarimg --version")

    output = shell_output("#{bin}/zbarimg -1 #{pkgshare}/qr-code.png 2>/dev/null")
    assert_match "QR-Code:https://github.com/mchehab/zbar", output
  end
end
