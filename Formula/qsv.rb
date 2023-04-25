class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.100.0.tar.gz"
  sha256 "08e0825bbe3fb78f6696ce79f7e4ad7c79a7140b12819a28bb4ead4909525efd"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8f1fa8b1b71c8a935b6132c2897e3946d5af95f5ccaea62a57d09a80d091e24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ffe42a367991898d7287641166dd739b795c46087619313f96d3547b5ef276a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6b4d6152a29791a9aebd7f9b01c91a69e33dc508632daaad955a5aeee10e96a"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c430cf23f51253603a48ef4aa5469dc7502c27aefc8e124e012ee4035c945e"
    sha256 cellar: :any_skip_relocation, monterey:       "7361852952892d2fced447f9b8a6ca8ea289e8693b6add60f670764a68b24324"
    sha256 cellar: :any_skip_relocation, big_sur:        "525384dd8855d5be52f12be6c65d5fb018dcf93087333cfed0d00cedd74fcb25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4d4f8fc4cf3e7d7bcc7a99112c78bbd0fc7c86bcf09e930310c917684b0c02"
  end

  depends_on "rust" => :build

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
