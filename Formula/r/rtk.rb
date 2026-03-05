class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "af6871eadc1260a8a9ec1cc6fd2a9cb1355539fde6592c18132b42d2607f2a70"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38eb3a3171332808871f706f55ebd0ee46ff8b3adb602d219bd6a88fcaf6cee2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e67afd05a0d8b89052ce9922db3c501e4e3a173b45b17b19fe0b3b6e4da506b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02290d72a2e2df400b37b0fc08191a500db1c10d90390ebecdf30233f6a668f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb4ecaf53dbbdca73363a31ef0f42c2b1dda5b36ab1a558b05deea73819afa34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2293025e3e68879e08fcac0fe8fabc3d835afc058b95ea519e997d11af8fa293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16e452a878cd2d2d4fa5b6c55ec8c6fb19195b95b6110a4dd340345ec9fe44ea"
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
