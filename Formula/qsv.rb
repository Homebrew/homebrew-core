class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.93.1.tar.gz"
  sha256 "1dbad66be6f318a5f5e4ff53f9bc9560e1abf376e9cf7fc4b13602eb45907dbd"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36414727991f21961d4f9defc516ab2cf844517bcfba444a7c39c911b95984f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47d9a69158b88acc61921efb475d9c9db3647c5dcb81f6a053a20cd2af7d3413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "844dbbd485945a0ba2e350296747a105bb8c9f8ccc57bd3cd0fefebe68b1cc31"
    sha256 cellar: :any_skip_relocation, ventura:        "58b08734f9d816805027b5f19f8caf2a7d5c5d87949fc90353f11faf953b5b62"
    sha256 cellar: :any_skip_relocation, monterey:       "18806ac21231142905af63a9b6727bf76c76bf3e31927f7f95661184775a1c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bc5a30eec9863dfcc87afabee1bb39bcef4109eb1a0ed2c25bcbb6494367293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1f2e3c554d0e705125601559650d36a77baae0f6dd46bcfba8f1063318c0c40"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
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
