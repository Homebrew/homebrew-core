class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "2a074ff11d538fe5f35a95d4de94602c745bd610026ff2e3137072f3f77dc7b1"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a566c99d100550c20273ccc979c1d63bbb9634c43101ed6e502851a08b0f6366"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ef48e0527e73fc6a6e3bd91e2ba0ca405deefa0dd42544cc66f8877df206310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced865a12523e50462035d37222423888e98cfc40bf35e0c34a7bcc6254d58c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8743454b78d994eceaf08b101be49d448a55f4a60afe84885fe20ad3db24f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2e7b072d8706a4e3e5432f79cb1ae56514afcbe8148963773264c6e00d37531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431f6a086842c02fc092c989cc8fb3328d05053a3f5f28e706cc78a90a69db2a"
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
