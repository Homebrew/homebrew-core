class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "93dc430b08e4cacacad5cf63bcacb2fe514c6c8e8d411ae6ab651df3082a4ecb"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2081d5ad2ddecdab9ac757c9604ae4c348284bb68add49c47355b471efc3a066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da28813333a28a69a111a2717fe0626a9bb5dde0ebc154a77081165afeb040f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6559d11a97c1e0bbd8007b58852e7c546117a64fec130ea5b25f611fac22645"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2a977b5c072eaad2656775ac875775af76c728b67f277670fc485ee622a948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82f28d7e4d040012bd3a9447e8ac9fa4a0844fb8e94fcfbb3694a3c910548b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21ed971c0bf4d47b891457733e029482413a7186d9db8b7eb99c80213ef647f6"
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
