class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "3776b066d26199d8932b564c7b919cd0a8a377d0d492dcb9718a1310cb7bf715"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19974df3a716ffeb83190d2c5d5c2f63072c51592ba7ca5c92c37d558c58c97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d52b2e431ea05410e088ba91a8cb3704ca357e1c9453757bb8d81cf2751d055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "188a28589f769c76681c3c42e3b6660f647a1570c2e48dd62c7cb6c37415215e"
    sha256 cellar: :any_skip_relocation, sonoma:        "400c51d7b0910af61cf43352737ff890d1cde70af060ca340f1a717bdf6cdc5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa3372e928387a55dacc8919f3fe8b7f025c3bce6f35cfca12d942abd7e42f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "208ecdf378eb0f40077431e2853f082f41b5c729ff366718165eb5b8a0623bbf"
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
