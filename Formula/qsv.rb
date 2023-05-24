class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.104.1.tar.gz"
  sha256 "1ca26ba7af252b026d1a34ebc16e55f7016ac69748054d8fea393edaaeaabe69"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d621d41e2c1723becb5a2da3870a0da7628866dd18bd8928165cf6ae94d458d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fa5cd69fae5d0095a7463c9ec83d96802efeb07f04a05e85dfb4c359ccb0a60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed41334c1035ae25858dedf051fea0f88cd1425044bf665247e322964f9bb541"
    sha256 cellar: :any_skip_relocation, ventura:        "fe46d4d6afb146e33ba991d1581b51db0d41a0d6458dad43963f03f9b95f27c5"
    sha256 cellar: :any_skip_relocation, monterey:       "edb380962009291da027f939c3e3b4c1644eb00023dce9e4e2b94c00dbdcf04b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2e25302c65065ee4f1c5d3734851a90ecb53f8c3b6a156371359f6de22c5ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caa7f57f76bdb1b19073b45924983c42dadb64c5d674c07aecd59b86c2c29c1b"
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
