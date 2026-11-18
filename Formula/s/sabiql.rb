class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "c2a0ca871891518f875400947ab550230d34f670767b5108215ccb5f460319ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9b7a5f1f4b686c6556631f3d56809b48bdc4feda40704b037beb9ef6c40dd65"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a23c4c1d626806444ed389434a589dcd815ffc9625411c553cb41debdb404d48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6029c9cf183785af7d7f6f9f0f4e18cc14d82c85083f9a781467897be2a5c472"
    sha256 cellar: :any,                 arm64_linux:       "87c055b3652a1505f8df497c501fa7b59d8d563671aba55e860962122a203fec"
    sha256 cellar: :any,                 x86_64_linux:      "4409c56b4a2f0be182bcaee6d603364a5e2fe585ad8f9db372b86af864079774"
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
