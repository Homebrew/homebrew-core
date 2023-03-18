class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.9.0.tar.gz"
  sha256 "325f16df916e4192d56d589839be474801ffd3d6a105f4a1a033221570ff6b56"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f381730f7272be8cb2c0896b0fcb916151d84fb9ab83ae47a43783eef512be4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "200ceb9a2a92ab5e15dc643e673e87222842a41ab69dbb90fc7c016bba5859cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ce70c826e792f2d5714c786c36b77cc596771a4bc18f17bc1ca22a3afca1e6e"
    sha256 cellar: :any_skip_relocation, ventura:        "420da5ade8bab468f57d324ff8682f5ba5bcc3c2333df6c89f1db0cb512a02d8"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd20145df51c6f4f0c561099cbba404799be68f99c3df2d252eb18dd550c958"
    sha256 cellar: :any_skip_relocation, big_sur:        "83479305aab8f669f1d6a5d7cbe7b5c4bb1eaba14f4322dfefe3fcf73c633cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0adb4dfe18c2d5fe5ef4d84d2b1334b64d3f311d307905bc25c28afdb8feaef3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
