class Rmw < Formula
  desc "Safe-remove utility for the command-line"
  homepage "https://remove-to-waste.info/"
  url "https://github.com/theimpossibleastronaut/rmw/releases/download/v0.8.0/rmw-0.8.0.tar.gz"
  sha256 "17b11b771befb89adbd7764fb897dff1a32eed34f8cd4d8b495da7f2a66de3b8"
  license "GPL-3.0-or-later"
  head "https://github.com/theimpossibleastronaut/rmw.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "383d2b2a02e8fcfd416e4b2ba106049bef27bdb3fc3f37f8fcaeea62b827b2f4"
    sha256 cellar: :any, big_sur:       "0f7135823daa0e0da7f172b24a173b31f39f9f44224fb0b1d623cdc9ef9a2077"
    sha256 cellar: :any, catalina:      "1d7ad66efc9a6b312b58ba471ed53a7de0ef30e879a6b02d321794d0856a61e5"
    sha256 cellar: :any, mojave:        "9ae98484dc5bc1bc0ecea7ef1c1edc42249a9841844283bac995cb5c6817375b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  # Slightly buggy with system ncurses
  # https://github.com/theimpossibleastronaut/rmw/issues/205
  depends_on "ncurses"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    file = testpath/"foo"
    touch file
    assert_match "removed", shell_output("#{bin}/rmw #{file}")
    refute_predicate file, :exist?
    system "#{bin}/rmw", "-u"
    assert_predicate file, :exist?
    assert_match "/.local/share/Waste", shell_output("#{bin}/rmw -l")
    assert_match "purging is disabled", shell_output("#{bin}/rmw -vvg")
  end
end
