class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "834bb6495e645b1983c48076c42eff3b0c6f769a7bbf6084b0de2ab711e861cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6b47c3cb924b4df1a8428c1c03b05e7c5cab740a4cce9804d8ee58093817f78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06cb9440cb6e8384f8262d683ac5cb2418319f3556f7b80af4ef71bbee6c382e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d925e393da855eb2fffc83c896a8db4e3ce5ccc50812faf05ffe59795b557b8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ee3cadcf6298358f56f24999bae7320d63f8ba88966d4657d7c7f2639b75561"
    sha256 cellar: :any,                 x86_64_linux:      "550090e6eacbf814699ca9cb63b3bdd3a996c7e377f69d1121c9bfc15fe83aa4"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
