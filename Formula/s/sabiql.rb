class Sabiql < Formula
  desc "Fast, safe-by-design, driverless, Vim-first DB TUI with ER diagrams"
  homepage "https://github.com/riii111/sabiql"
  url "https://github.com/riii111/sabiql/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "0de29f3b267c2258c8d426281c20ae214388cbdfb06f44885682d308fd0f323e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "843225fc3b536612558d0bf7b5cf35053811d1d9611e02db4ae9e69d33129650"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18b020ba7e157fe890471d67174244a8cdb567b4761f2a141dbbe5e942f6e031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3a66eb8977f68aea7d743682c109e0d685ae1d3cac9db885d9f40ba382b3490"
    sha256 cellar: :any,                 arm64_linux:       "0e0d477366fee0a2c1778636d67d25247262cbc36c647192f9cbbdef1bb4c5f9"
    sha256 cellar: :any,                 x86_64_linux:      "fcb006ecf2ea33de9d7ecfdfefd68d3e71c56549e43275785dae605c0c84ae87"
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
