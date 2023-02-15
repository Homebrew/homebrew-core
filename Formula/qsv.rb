class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.88.0.tar.gz"
  sha256 "7819f38e4e997a9fec00df68c5d193dfa904416700dbf261930ea62a6351d3de"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29b49ca98f0bd9c15cf24a623d170b216b0b05e6543136236729ca62f7f7ac4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e4116826c030767cbf09441854c1e0b5638c95c7f4e46e37141669a3e33d485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fedafc4d2c84548351cc62e8888abdc4ee4d9002a9a6cb17282e953dba98aecf"
    sha256 cellar: :any_skip_relocation, ventura:        "235f2441e2e919d5b2c4439c8fc6e4c5871d71079768664e50ed57143c7e6968"
    sha256 cellar: :any_skip_relocation, monterey:       "945183313fbf4855a9d5c78aae92fda8c17e836240abe8f00349ec185f422d83"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8fc33bdb81e974494301fdb7787fc9f3fdda9727f38a9a54b192c1f966a3843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a907f38f8f4fe08d0708409176a557c9c24dbbe58f012f19ec0381556e8e115c"
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
