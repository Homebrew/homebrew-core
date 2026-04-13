class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "5df52f759357a87c8252972818637bbd4f59f74ac574c6b144d8318eaca908b0"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "907091d83178cb6f6ea0370405fedc58a9bf8cc5c25cedcef42058e843be73ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a542753facff3e14d9e17e5cf93d8954439eecd7f8ba7827ea461e4215440f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb534eb834229ea9652b4ba709b3ea28896ee51d99ecf3428adb44deb3a2230f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c57f16285c3785fbdf80aed015edb03496ac0e196c635756c27857069f541e16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ddc4573fdce4e6c02521190419117e75f7ef48ffcb652d1ea38e4681af8fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d07fe22f8e5a5b98b69f513bca03c0595e172acdf8b13cde8d73b379990ccf8"
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
