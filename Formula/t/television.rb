class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.6.tar.gz"
  sha256 "fe527628b313dbb4a5d3f2518bfb1b8b4969bd7d91822c216ca3de294010f0d7"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "095cad3c3a5e485873d8322b00c33aaa13762637950743ab982b4055a94af9ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c61f457eebd4baeea074a0ade1a4d7491a39387858c5d3f87ebdb8d060ca4ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3142a32e9204c36af85b685c4238afb3c2991483ab53b8c1adfa8ab2d7f050b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d129b7573f4415300664c2a4062918df8bf425411e2a35e7edae2d009c0b021f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e830778d95d6a31a80b0d720b1f4b27967f2aa7d14772c092d11566cfb21fa42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e280e87e24457049eb2005c0a03cc4e040a2f4aade1e10a45ed65148357e5742"
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
