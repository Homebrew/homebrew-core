class Repeater < Formula
  desc "Flashcard program that uses spaced repetition"
  homepage "https://shaankhosla.github.io/repeater/"
  url "https://github.com/shaankhosla/repeater/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "908300013e7e2722b044aa598d0c9ffb799cebf9214fefe1be3e67958dcfbe23"
  license "Apache-2.0"
  head "https://github.com/shaankhosla/repeater.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85a9f6a372e594bca5d3dfc2db2e634672ebe9528768f7cf36bd0d5c00d633ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f66abdd5243607bd331fc61ed902d464056d9e018244231d87c00ed16b5c8d2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aeb0ad7c7bbce7b997be93041ec8a14ffda2e23d6476e2173e365a55f63c54e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ec3344b1926ae473948d91499ed759c487135e298d71fb964c56920a0a87bc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5140a9e42439839e5686d8f8b845663d897c13f96d6ce8561904bad8b829c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3d2a23925c219e7f660637fdb4481e56126c385f9f3b38fdebbd055820cde3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repeater --version")

    ENV["REPEATER_OPENAI_API_KEY"] = "Homebrew"
    assert_match "Failed to validate API key with OpenAI", shell_output("#{bin}/repeater llm --test 2>&1", 1)
  end
end
