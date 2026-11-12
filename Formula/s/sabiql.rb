class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "0de29f3b267c2258c8d426281c20ae214388cbdfb06f44885682d308fd0f323e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e77773f32581d5f0b9359edd8bf1b31b0a750d1cdace3e2b187d1d1107959ea5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e713ffba2f4dcfd1c74e57775d9501c2249f759cadcc0035128afd8cf4d2dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4e983e5fe1fb85a211bf32db35da83a7b3dbeb7a55c825192773892483a3707"
    sha256 cellar: :any,                 arm64_linux:       "e32c00d41fad873cc09bc7fc8058b9e030a895653dba2e0e7da45020b853a423"
    sha256 cellar: :any,                 x86_64_linux:      "7e5422e9401edc8100473cd11f6d71c38af940eac86ec1e4f689d284371b1624"
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
