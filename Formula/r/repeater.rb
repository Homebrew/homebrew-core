class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "9620fdbbbaf4befc28afde38905c2915a31fc551b44f1aa6838a2f2bb8993892"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b6b7b9b4e663d6ac2b1358b015dc91d61ccb0c8cf7cb7a09244b3448d341df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72951d823a1a3686df4aeab50866b04e3b18f8ace1e042056169b25e6258976d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc02b0a95deac63e43d0d3acefc28f4f7f240343f7a87ede4e47eed7829fb5f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "722d1d291f5fb68e065e3dd4f2b73abbb704c759e62be20b1686ba29facb58a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a371e59424a7a173bf3f0b736f7e7ce29b3281464d0d91097a01782f2dd47dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53e72d870f45d412e0dc018acd7cc0b2cfe59dde367fa366ebc67d8823f0f17d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["OPENAI_API_KEY"] = "Homebrew"
    assert_match "Incorrect API key provided", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end
