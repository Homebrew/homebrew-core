class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "2d31f72ac9df81ddc8b5ecb9e5e539c754c22863ada3e76e4c1a88ee53c99a21"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0eb9d08aa6de8c090a446b07d3fd468c234c4f870c3afc6d155b67c6844b6de2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac4335252ecda470fac92478734cd6b69a23ef724ce72ec31101b06f7de0163"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abaa690028023fba3c32e5ab17a07c7ed9e3de0bf781565363b56cb650f3f284"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8d029bcc60c8170fc082215034dfd073a46bab05592e55671a548a238f7067f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b400b71d8eb2552020a161c3d40c905d458a9b9b61ded4058d1e8038dc376aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af566891c0c11afe80f44e884ce7a4074b7eeea876b2484c26ce591a49dc4f01"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
