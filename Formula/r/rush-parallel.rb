class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "82d8496874631b1b27618e3a5c1d95d3f5610ab5a415341a2115688b12bca4dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00796ccf7f1aa70942a049864482a86b7d9915d0410751ff47ba6834e6857e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50a578f2c64137137d1a004e8535c6ea74cdc43b971bade54b01142f289e6d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3894ff541972e4f7294f7d8fc5ab23061437f2004541419165a99d6d4c709959"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eeac0ea0161b5da75e833e99988060a35e6230d1956cc885022deecbe069714"
    sha256 cellar: :any_skip_relocation, sonoma:        "35f05c81215d36bd242affb3cd4e2f07654b2e5b7b114470acf99adcd147e062"
    sha256 cellar: :any_skip_relocation, ventura:       "e696d0e4b1418f63075cd93842c973361960097fa153594191e67374e4208a96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773d308ffad34b476fd539d714b2a381ec32b0e24cd2f13bcb4618b2eab8b309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a8e3441f54cfe73b04d086413644cca6081a6a7b06273a292d4c3116682b36"
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
