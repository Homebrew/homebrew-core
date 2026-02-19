class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "a43547dae9d21a228b34d17bb119be75d2bd75d0b623c7f85c3435a2f8be49fd"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17626e374cb42bffb39971fb7143dc3a765289588f524cb45d285a48cde04542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f04e08355bc32a4ed1807a89c21098c42de6e56e81ddcead4ac4af2ad77c19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6985bed8ba297589b687c2a8d779e25c561808b80d055ed42ea670b2eeebd2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf8a7f139c36a0797e575b98678000fc1075be2fbd23bc3165a6e10e7d1ce0b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b0e61407a30403d6530ee579cd9866c42120dad7616cb58d03abd67943e4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5974a529ba943738bdc1fd81b28c3b8c854625b410caaac1d8d65ac187dfa65b"
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
