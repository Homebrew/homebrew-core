class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "fd66bcb2c74c596b133b80b5a136adb6c1ffd241543766cfdbf404f75e110c23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc103856d3f9a3dbd631a48c6d91a07d8cd8b9bfa51375bd17bf899b34126d51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5b0728bdaf4904e6184d1753c3e6c10ba3a4adf4affcf898fb9b5e92a46000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcc56f0174d8b19834be7433695b433ca1a9fce66554c89ee1b4b300a8a0cb0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ef75151d79b7f889207fed597f85b5cee52609421fa952a4c76e853cb5f829"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f8521237cb6c53c8c3c2581e8bcb9d0f3db658a5c785770787bb8cef50b7651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d12a70da9bf2790bf7789f1f35ccb13c07614e635ce5023c2dbc7b4e55ccba40"
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
