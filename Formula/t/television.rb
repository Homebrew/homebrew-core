class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.14.5.tar.gz"
  sha256 "6bffabdcd03672ec014bd9a3f6a262d01eed0127df8a308a1b060a68c7580704"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7cd82cabb2c0d51a81ae4847b0134e254f6bdb5e63a5d1fc39d6e410da56b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "579ff30a2bf2497c6f8f0b7220129c4bf223bb028d6a1396f389fa9d63e84d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23ae40c79573b628a9a19ce348bf026a9f89dbd365d0beaf21b885bf43b77918"
    sha256 cellar: :any_skip_relocation, sonoma:        "44594b446f3c2052bc9d463c70625cd0b6ec4380df18de78da8c760c9d4660c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd4a96f6cce9ef5a3db2a0341741f765b126ef26e532c2253b8ae17543672ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97b3e87eff686191d0ec92252d7bcdfef752c36f8d81789404ad29fd11195836"
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
