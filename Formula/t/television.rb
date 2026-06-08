class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.7.tar.gz"
  sha256 "e30bc41b074565093099d4a4403465f3f6d3e852af22ab423348b9dbe211d8c1"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f108106cb92e9c26a701d60a8bcb4830cdfa9a417990ed3d84eb6ef4da15b1e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "041ba73cbf8747ffebba0e473a3f3256919c0c3724da142748eb7ff1adf704ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67a827da3fe2ed131dcbc4275e5d63b571cdd673e2571574a4b0ff681534bfa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a348b2ead370872787dc3802166fc3b58e8de2e8139c46062bb6b153c69573a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27b26d1cdfc302a755c20caf6f4b8af3a0e154fbba85c305d1e4d0df5511df97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dad1f4f1d0e71853f52c8aecbebb0931ad127ca4e5cbd3e27a0064ea8c58a72c"
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
