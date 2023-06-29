class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.108.0.tar.gz"
  sha256 "6f191a72b9b6040805c27ec6dc1d2fa037088970eb4c42af950cf701fa2bdc8a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaca3ccbb2d3b14d9e32c1541c9fbabec802efb8afce2c58fdc054a7f7404e69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ec9f8727c7d8cf8b5b1f1e5bd6b1ac40df7221c6aa42470fc07dc586d31de22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a39fd7a3df905b777dea86b1a075dcf25a4791f2e49229a31aae6d68dec99e14"
    sha256 cellar: :any_skip_relocation, ventura:        "248fc8da0f637c5924184458301fb9b758633f3bc1fee51f7e416a7b29029276"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7a993dc0b08f06ee2441c3e8a705b599bd981b80caf97e2e1a13e41b89a9e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "59162b34f365b790870e2ca2db3630a85ae63ad6d3eb99d4536cc814baeb0690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51653db07d61cc44cf7e85ca1d5c221e86138bd4c3f3db1b71dde6c82a87c488"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
