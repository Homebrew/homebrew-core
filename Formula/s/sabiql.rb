class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "58ba2cce99506d23ca9030c596a3e0329a1b472bdc4929657330c6539aa2ff13"
  license "MIT"

  bottle do
    manifest_sha256 "149e282d2852ac01cc946bb421cb37165abca4706fc25c0fb1ee1598d8e6f790"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "226588f5873e06c4f8129514212aada561de0363d20cb2690ccf02d04c03038f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c9da68d15d6abf2f6eb024bd827249e3e7a3fbd662d92dc5aca1f4971bed3b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b520d05217593613af3449a7d355dba62d1d86031bd140a7cabbef03afd25b06"
    sha256 cellar: :any,                 arm64_linux:       "5bf0188917aa38ac0231c1fee2e9d503286ddabc9ff1a0e4b92cd995e74d935d"
    sha256 cellar: :any,                 x86_64_linux:      "05bf3e7a458c47b9cc3d8166b479758515d9c4e0b90fee135b026c06f6500f52"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def caveats
    <<~EOS
      PostgreSQL and MySQL support require psql or mysql in PATH.
      ER diagram export requires Graphviz in PATH.
    EOS
  end

  test do
    # sabiql is a TUI application, so only its non-interactive CLI behavior is tested.
    assert_match version.to_s, shell_output("#{bin}/sabiql --version")
    output = shell_output("#{bin}/sabiql update 2>&1", 1)
    assert_match "brew upgrade sabiql", output
  end
end
