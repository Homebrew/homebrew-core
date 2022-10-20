class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.8.0.tar.gz"
  sha256 "e58e0936db25c81ff257775463f1d422d97c706aec2d0134e39b62151ded23cb"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5812d1ee1b84676ed4f7f40e2b6bbd637598994a6972e2f5f374951aae3b9d74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d63fb2bb636e28b0c96d1fb30a0c96ca2b9d6d8ae96cf759b5c188b17ab01bd"
    sha256 cellar: :any_skip_relocation, monterey:       "62f24fd28f1c34d545901fd9f1131c9b68f4dfcd3c24b80f237786a2a4773d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05e79b8400ba8d0ea9951e049b60872f2b0a5cdc46eab2a2f0aa1d9a36517b0"
    sha256 cellar: :any_skip_relocation, catalina:       "084ed6ec5118a90caab68edd0f18921f21b2ae4430dca72eacc346b411ea825a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9ebf69fb2697860406c4d8f2cc41e015be8ce6a763eaf08d89cae0ab616b991"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
