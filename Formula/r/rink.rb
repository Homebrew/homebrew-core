class Rink < Formula
  desc "Unit conversion tool and library written in rust"
  homepage "https://rinkcalc.app/about"
  url "https://github.com/tiffany352/rink-rs/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "40048e84c2b606e50bf05dec2813acedeb48066cd48537d0dea453a72d000d60"
  license all_of: ["MPL-2.0", "GPL-3.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb6d58f1c8800dc3c366f4b4593b1d4af864d63fdee448aaa9bd60b72ff69ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9e9d83c728a0232035908223bf1d4b0823c6c96eefb95d72c08a060f9e8c1fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886a2268e178971f189a726cd76757c20110bcd2fad8cb68ff6bb911a93519e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31c09a811a1d779c6e9f1edbe8d03cbabc5ebdd2b2f8a0117429eb93f3bafd55"
    sha256 cellar: :any_skip_relocation, sonoma:        "f28777dd190d29ef41985875425eeff527e18b6a7db4976b103323784d36f678"
    sha256 cellar: :any_skip_relocation, ventura:       "78257335a434a84394810b5f47526553c58d1e57a906f1fc1619526e978c1d1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca578f08ba68e204d37c59d253d50715e7ce4d450d73af1604c66867423eeeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a541a87a97cb62583bceced14bbac8c03d8f0119e6702c1d773c3fc08a3e8e3e"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    system "make", "man"
    man1.install "build/rink.1"
    man5.install "build/rink-dates.5"
    man5.install "build/rink-defs.5"
    man5.install "build/rink.5"
    man7.install "build/rink.7"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rink --version")

    output = shell_output("#{bin}/rink '1 inch to centi meter'")
    assert_match "> 1 inch to centi meter", output
    assert_match "2.54 centi meter (length)", output
  end
end
