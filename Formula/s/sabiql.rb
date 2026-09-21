class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "745738d629b618f7f02190c176a89cebec29bfd3dd3877ebc12cda5223e8672d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab0f2cdf21655402625e66d0c17a042f5fc1a670bc2111a20b4d2bff546a0e2a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "765f04b10073dc4a8fa13863905ae918b5689ef4021667995b9e89603a59eed1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1638805a8b82f31ecdd70a228337b9170dd7a06bc45153cbf199528dca47a57d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "8cdf78df355127ccad32e9b734f61b83c3ae1e877aa3bfc4ed4791dac867eb38"
    sha256 cellar: :any,                 arm64_linux:       "a25af2104ca606d3ef04e74dc93264195811d8c91c95f960e4133fc2db6ffff5"
    sha256 cellar: :any,                 x86_64_linux:      "77d2dbd8129dd083ded07c2bad2b7b8169575f655b850212cc6409d3f43d9d00"
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
