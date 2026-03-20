class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.1.56.tar.gz"
  sha256 "7658dcce98235580b5e45b00ed3e0a8c658da126580c96f26a5d27dd55a0694d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9959cff7ec027cf5753e7f5c19a0bbb35251b6b54b66d0eb58b4206a4c2d60b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5696a199230fc459222f253ae10b5edbfbcd2af81440000195b9f2291d17e81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "169b8ff70e1da1b901a88e8b56b16bd78e348f0b73d40a2ee27ff4cf54edf083"
    sha256 cellar: :any_skip_relocation, sonoma:        "3682709213448ce12147614b57960b27acd6b8ddd219952c7d42271884675f8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ffac7a84d915d3d6bd4e1a9d383b1fa35784a3ddff33bead976456c0eb0eee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19bdd3e25f1d8cf83f2b4deb6122d0e9385e9354c5d8815729e945e262396251"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
