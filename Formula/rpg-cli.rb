class RpgCli < Formula
  desc "Your filesystem as a dungeon!"
  homepage "https://github.com/facundoolano/rpg-cli"
  url "https://github.com/facundoolano/rpg-cli/archive/refs/tags/0.6.0.tar.gz"
  sha256 "eef8ec026d0f49d00c05587984e4dd24e477efeb4b674be9a5cb992be876b163"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0bd146083ed5b5591d1a100f7215d424311af4570e9a3ee2f56b6a27c91ae90"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea2253b83dd273c359c7f7da6075e07721de5fdd8881eb9232a355c04ed707d8"
    sha256 cellar: :any_skip_relocation, catalina:      "19ec602ca786895f8565143f89c7cdb77f1a73fd374708c753052c92bce6da90"
    sha256 cellar: :any_skip_relocation, mojave:        "0fba598c7b941d1e8f8c966afe4715dd7ef87723d6cf6143febc1bbf90db750c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a0064985ec8a483ca787855b43b9a3f4635626bf5026a666b12365d1910b97"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/rpg-cli").strip
    assert_match "hp", output
    assert_match "equip", output
    assert_match "item", output
  end
end
