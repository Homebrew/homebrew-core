class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9a5cf8f9e155491cc75e877decfa35c8c7cd860ed879247333a5c8384660359e"
    sha256 cellar: :any,                 arm64_sonoma:  "76309f0f2438be4e22807912c1a081674e2d3edee7f976b8eca234cba52bf52d"
    sha256 cellar: :any,                 arm64_ventura: "c04a1cdad577b8f573c6aa433ec6c2905cc56a51991293453c271aa059dcf09d"
    sha256 cellar: :any,                 sonoma:        "e1d327c7239a6fdfefaef78aaf1e778975db93898cead17a976f779e48ccf0d9"
    sha256 cellar: :any,                 ventura:       "3542b9595fabcd839fb1038d1819e2cd47cf429f8cab84ee60bc21daf8285773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "536cc269ec43894509ba9a294d2c5444648a802d299dececcfe977b0098801fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451a222b2d0b0b7cc2296e017cc3cdedcbc346bea401802df9031693a44df61b"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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
