class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.12.tar.gz"
  sha256 "7dac23f4f77fbe7eeea50ae23b2ab10f1fcec239e992a83dccb9e83c613a8dfc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a42bfecbf4bdf0ef5f7f23680e2d1eba89b34fd7742154853a042df5dc49738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06051fa90eb432fc773fe190b039633ce80fbfc845cccfc04184d819c0c4eac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "354bf5248a2b8b8cceec24d65d2d207f9aafd4112dffbeed749d4f004063f9b4"
    sha256 cellar: :any_skip_relocation, ventura:        "280e5f615660c7c12f200ba22db379b079f9cc08e1f4ebab64125b5417be541d"
    sha256 cellar: :any_skip_relocation, monterey:       "1ab3f4d85482a4142218ec9de9aade15eaa9385788e05eebb2b5dc3922dccef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c2e607f99776f4c8636353e7178825e3dcdd23fffa6777f02923401c82f13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a76b2749fb3ecb0912fe01edb69fdb506958a226ddb483f7995c953f3296a7dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
