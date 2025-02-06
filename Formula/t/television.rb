class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.10.4.tar.gz"
  sha256 "5e40ff2e9692195fa90234e2bfe080dbcf84d43af65702aeb9e86f36269143d6"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c507852d6b867ffe6979ef9ccd223f7e6fd3b78d6f04fc1ab74d36f8d431409e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c197077ee2775f0033be139bc8380207c0ae081b360c1b7639e72ac6d97174d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dbac3dac746f21ad99b8153c5446f8596c4224ce08256af763771e1f34f6f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa63d4e2ff0af926c5662bbeb6248daa2e34ba780d9633a1c5a8a99dff15be5b"
    sha256 cellar: :any_skip_relocation, ventura:       "39b358cb9433399a0fc59280eee3fb21ee941b716c8b4deb8a8865c4cf8ae004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c67c7bb41b41bac306143eebb0e7ec83e104c7cebb5729f1bd77db1ed892e3"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv list-channels")
    assert_match "Builtin channels", output
  end
end
