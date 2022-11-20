class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.8.0.tar.gz"
  sha256 "e58e0936db25c81ff257775463f1d422d97c706aec2d0134e39b62151ded23cb"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50c1e057b6269dfa785c658b12faed016d7f77e8634a26a3c7bc68953c87f9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed34ea3eb374ee4f4d24ef56761e598bdf08ffb70d1e1dee4b8c0859c96fa664"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9b12d072fd632baff141e138d9d91dcf4fe99af3821cdc49959f771d1ecfad8"
    sha256 cellar: :any_skip_relocation, monterey:       "51a780f70653818789135dd3f2ba35d39e037dae65657c8934a2d33a010e7cfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f65cf4cd1d603725e5b9028bea928568f4055d7d0dba023a7d1ea306ca97468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6710b464db2dd6b87c41aae8efe8c6fd87a667b86be4ba4b6239fc9fe28626c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
