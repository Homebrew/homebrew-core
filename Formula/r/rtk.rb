class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.42.4.tar.gz"
  sha256 "59c3864751715913c040732d216bf07114fb803158ebff8fe44ad7b23c3f5fc2"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "781942e9a0e7e9b5d8c8a18c47ba2aa0dd82052af282ae49ebb7b8ccddefc6b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cbcee1fcb19f777be28e41c2112ccd4a0a4c1e81887c9b2976d0c6c7ef42a0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a5353ffd88300e86fcdd64e3f0a6930f390e31a70ce5b07272d60a5efbf830c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a13438b7c9129e6805fba5d0f8ceea18911eee4627e60dac2eda579407527a4"
    sha256 cellar: :any,                 arm64_linux:   "47335f518833ed4474dbcea3d12c8ceec87da8d5f3785ef4980a0ca9d44bab29"
    sha256 cellar: :any,                 x86_64_linux:  "1587ba8698fbe1f9caba0ac1b2281eeca981be72ef3cf9d116ff1c362495c8d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
