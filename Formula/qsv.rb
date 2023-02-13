class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.88.0.tar.gz"
  sha256 "7819f38e4e997a9fec00df68c5d193dfa904416700dbf261930ea62a6351d3de"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "138855d7fe5b52f1cb0cd64ac82fe206755f806a59602156e2b571e3d7265b87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a097306d93eb24c21da26b0e761b2a1ed1999665b0a18be376cc77bbac16898c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb4288035e832efd05a5f7586ae6f2b941294d6328d5fb7bb42a43e075d0e089"
    sha256 cellar: :any_skip_relocation, ventura:        "617dac07c5a5ef1f5a364d68c63527f23a1d8f9b0a27f678ae59b9483cfc7d54"
    sha256 cellar: :any_skip_relocation, monterey:       "683f6cf24f2a61c0711c0bd423d641c980aa75bcc358a686f6609bdc58ada684"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1ea0b3db10344d6fe018108a06db388d0564304821a28f449495b4997829b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f308e8553b760483f867751ad59898f4914946994a020d1a10cf50cfabb8f65b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
      second header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
    EOS
  end
end
