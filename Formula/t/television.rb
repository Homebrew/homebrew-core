class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.3.tar.gz"
  sha256 "5097343a03ed140ef643e5dfcceb48a77f9c372dbd3d043d523e25f9c4016deb"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80895153a98219c16b21316bfdd3043c33eb5e4e813e108df3cbff3c8810e558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754d7ae87132c0d12918c836b97f01cdac9a89f34bdc300418424316e175c6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3052deea66f32e35eafe6fa8c556f66b29b8dd4c7d3b8ce687a369b6b4eaadc"
    sha256 cellar: :any_skip_relocation, sonoma:        "154bd67bb9dde3b8d522678096deecd954e570dd626fd936edd369e6422ce3cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8832131131f697d0265f02f37ebd5c02b91588f734c4e8718eb9000baf16a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23dfb05e30e4a9d9254cc67ce5e8f1b1995e35667579cebfb5eb479a715725ea"
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
