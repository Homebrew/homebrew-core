class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "0459f63cb79f610751974ba20732e273d45ddbb4cd0c0795768b62b868891ad9"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c848713b56fd2a857b0533929d016f8bfe0ce229eb38951281a8024485651acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd950e90f220f464ab38ec8e42be52701dddb1b0cf72b4d3e7c8b5c2d277d212"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8f1ba6e28e8c09a6df733e4583b9748eadfa617758a3ba3cce2e33d9761ce9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd0ac1fd871818d315c7c57140cbf23ef323b902e5808bd5e3f1b7c47413dce1"
    sha256 cellar: :any,                 arm64_linux:   "6982738e332b45a7b1fffa49839cb5e39b1dc8bdd66a603c078909eb7c04b593"
    sha256 cellar: :any,                 x86_64_linux:  "a59215da169371e19cf5f15a467dc4c922e44479e41a28188e9ef8b1fddffadc"
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
