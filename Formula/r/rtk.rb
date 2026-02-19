class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "684a5415396bf4c191e26971643690959691c83165ab3aa9f359dc844d9bb848"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59d90288c37dc5b86cabae8aab7e5c3a04994ca18112ee6e2101f08d1f86f4a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "230eb42d5be22ad888597b8ca48b6bc852cc7bfb51395431111f88747deefd25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f494eb3f95798bd9060d3cce6bfdef777216e8886e90d7cfc59dd6dbb6d776"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a7fe71b6da7589682adb8962be7ba5fc84497f5f0c4baa0625635771ec32de6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e5d8f7314c4502e360a54c3f5eb35c099e8057505a875a35fcb15c8cc5ab71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c191afb4d06241ee321c63511d53e17d58f50559637e03bdd159f014599d4a4a"
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
