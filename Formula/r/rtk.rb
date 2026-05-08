class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "1e96062e180b1b49f63c64ff225fa8b96cfae5d3f4b2bd3565d2d0eb2286dfa1"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58d217624b8d1b12c281d9421ddc0e2e85c5ff5048ab8cb592e62e61378c53e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ead4b9c3dc8decb23ce7a3c646e26022e03cd8f75284db97903a2784179ed0cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7423eaa1daa6dbb7fd5d1c1c414ffd8cbfb9fa92319c5909a1a8ea672e53398c"
    sha256 cellar: :any_skip_relocation, sonoma:        "177c30a9ee4338a0e7323fe08fd72adf5cdd973c7bf6ffba5326f69bb34e1914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "699a88b0a7af7dec9d7f0b92bd2076512507fa14c67826bdb64a1ac44af49da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fee52a793082c1655889f15307e1b71108ce08c352647a30450635a12bc3e2b"
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
