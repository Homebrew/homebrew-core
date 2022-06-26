class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha256 "eae4c8bc16dbfe70c776d990ecf14328acab0ed736f0bf3bd1647a3ac2f5e8bf"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1c485dad29e5a373c5d6a973a7c36cf2de7bbecc44e07bb715b126e9fe0ea1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4d9ab76457599f2fe20875e9900c1d1f330ba7b35d4383e99042b66b264de3e"
    sha256 cellar: :any_skip_relocation, monterey:       "783650fd010e84cba76c1d747d7948fa1ccf0ae17032e797d76920b291ff36a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "236b80d46f0cbc8aedc14b6771b4b58cff6e445eb2e8a115ae14917b307fbab2"
    sha256 cellar: :any_skip_relocation, catalina:       "653be227eb16e647b90f0f034543a490476e3ceaa0e9c165b1963b916b4a9703"
    sha256 cellar: :any_skip_relocation, mojave:         "27786a7ca63d00ecb47e9f1e3e844a077d38048871cec3c03308831716338dc1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fe9a704fdf7f24dadba6b4f7cc20f8f07d93c19450701e01b408ea2f7574ec63"
    sha256 cellar: :any_skip_relocation, sierra:         "30f51d2886adf914eef22af21dfac92f544c59c88b6e7961972eb6702e48d0c0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6d838378cae0971561da60dff1e887bf03b60d1a0ff198a5d468654ef790d9e9"
    sha256 cellar: :any_skip_relocation, yosemite:       "29291fedaa06b7b680e44e1b82f643f7ddffc67435312b7c2f3654df0728cb8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7bd15bf5407710e19ab7c3bd414c18b163b251274d14e058208a526353a7e0"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqtop --help")
  end
end
