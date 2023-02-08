class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  def install
    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--disable-silent-rules"
    system "make"

    # https://github.com/alexkay/spek/issues/235
    cp "data/spek.desktop.in", "data/spek.desktop" if OS.linux?

    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Spek version #{version}", shell_output("#{bin}/spek --version")
  end
end
