class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "48a6560f32bd5445eb7d19ce594c640875045edac965cb963fd929285ba87f6d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ffcdb2c860323b189e6a902b8a15ebcca4e54516159ad3c1799401cda340b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee046ffd999162c6935d400162ba77f890919d00c1b7e011e1396b7c39dcd2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed200d11088e84ad20850ce2368a47188104f427d860189a4a9f268f62d1d418"
    sha256 cellar: :any_skip_relocation, sonoma:        "26067667700bb3b6dc7bee73a980cd2ad762fbe0232c3a4b7d0a7c9f4233f1ac"
    sha256 cellar: :any_skip_relocation, ventura:       "7820ae2b68c5b49115adeef678fd44f8c61fbdefd2f7592bad4aa5159363702d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15984a832e5cebfbd1d3b138159254acb61e51728b0ead3291f37a39b13e108d"
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
