class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.13.12.tar.gz"
  sha256 "bae0aa3b2df57417321f237b77aaa0a40a533988f33e7c05b68ffab248768206"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8c7f424230275f2bc4692a77965417e5d8e387824c4189d7938d02a9dd6aabf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9cfd7411cad002a1927d9388c4521cf1c6b1dd40589d805912080006f46ba4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e56861cd832df52b622d33b6783a027a319ced8d77d4953da126bdfea28837a"
    sha256 cellar: :any_skip_relocation, sonoma:        "de553382ef4df7b839d80f26205b2de212b4a24b7bdea9005a15276df86f6711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddbe66df533ccac873517422eadc9ae72ac1f723773419be4e9a88ba4da7e9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5caa6b23351457d5c9fae1e822921c6b5e6c4ab36772386d8485f6c66320a0a"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end
