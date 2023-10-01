class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "792a1a1de73bf4145ccaa71f8e6bb34b62e690270a432c4de4d8639e1a741b5b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3802468d07a81cf690e8bfc4c2784f6b4b19bbdf13606a4148b9906eb5f02298"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a977d485854acff1b6b576819a3b9686da637c5bf575354bb018cb714df729ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eeb54767d8aa63e78d9edc5e89206bdd834deec2493646206f8c443e0a1b125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5819d888c2a9660cde2099fd573f14fb0ac22d285c7ee0b02a9a7b64b5cbd5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7898690785d25ec0ce0deda78cc95a730023b89048765374ee4d4f95e86b02c"
    sha256 cellar: :any_skip_relocation, ventura:        "872a4d30a206f9005d0499433381274d42845e6d0d59d7f7a5011523f1b05be4"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f6ad7f96700aed729f8cd4ff4dec39d5fec30d8339cce3c6593a623c87db96"
    sha256 cellar: :any_skip_relocation, big_sur:        "db4fbf1c9b0f2d3353b5f7c871c53af25d20b3f9e5f801349fa37ad2f5ad1c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4330a52a92ce81dfc0e26bbeacfd8141e176c09e9a9dd05905d5e84c277197e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end
