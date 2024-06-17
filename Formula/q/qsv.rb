class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.128.0.tar.gz"
  sha256 "c3a6787406d5e7fcbca0f8d2a0727b198ef582d22c4aeef467b56c2384d02d3a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e78aa51ca3ace7d24c13c305de2cb0064c1cbf6abc8413f1848699e72c9e0793"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "184ba42364d8bcceea88a71f405b1e45a4bcfb9441156ee7df786ac2eee0aad8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9513d55893ba23a1b39c6e5798310720bc8bcaf699a3f5c9310e912b53c73502"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbee4dede241bcc40f487cdf4844953e814fba7d8dd6e4492fec3eca1aec5612"
    sha256 cellar: :any_skip_relocation, ventura:        "c8dc7beb648904f514e9dbb1c5acc521212d86fce6b85b1c1eafc7ee80ea8483"
    sha256 cellar: :any_skip_relocation, monterey:       "3e369f8f194d6ed0f572f804933a6a1e84f40a09981c74811c9148c6d452dc64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4804283fdc34e35ad3953d0295d4614cbea5424f5cbd154f7efa54683f5c1589"
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
      field,type,is_ascii,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,0,,
    EOS
  end
end
