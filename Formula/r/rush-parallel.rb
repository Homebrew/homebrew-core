class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "43ccc98c3c53b3995ee98fb1195ae3cdb7615c7fb8e4b2a6410c100733c764dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee11479dc282afbda33efbafb324069938d3472caa592f59a25ec22455247f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173674fadc307344730628de968eff11143ce4c85ef48ef1e3d037e1fca77340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8653c1b7e8e3baf830c08ee7019b112535aab3143d700dffff6afc50ad48a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bc8f88a147545f463b1245413901ce45047e4c0b6424d781bade7342d15bc9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88379e8991cfa8f171455f9deec6e4f924274ebda99aae0d83200f2a94986c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449e7441ebc29bbd5d2274bb74746603f8c61c739755824eedf6f7db0ac99601"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rush")
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
