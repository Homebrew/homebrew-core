class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.87.0.tar.gz"
  sha256 "8ec0363d941d351c8adb15ba786b82747219573a4c1147ee5093cb9c1a6c054a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfce25a821827f059cad4617f5d9bfb91f331b2ca18cca8bd0e066e6cf0302e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "755432c8e8ff73babad92107f2ac067fa8f4549a330cf2229239ecb7cdc6a89b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e2523c13403c177c7beccbd14daaf85968a0ce18a245a883ba15fcabacb78ba"
    sha256 cellar: :any_skip_relocation, ventura:        "d883f79d180b356a5da9a9d932527cd74174d7a8b1f3c1f23cc8503ac554e27c"
    sha256 cellar: :any_skip_relocation, monterey:       "4bff3ca9a0c43fcbf5c931ca2ac82152ee84e3b2ef20ad71f6eb82a5059dc8a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5511a8d725bf32430497d4f966d6e7808d4ffb7818ef12b910d8c5f64a04ef20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9306aa4df7b0741fba28e63b128210cf6d59f9e3417dbae2b5fad24c1837188"
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
