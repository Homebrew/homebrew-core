class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.62.0.tar.gz"
  sha256 "815ff78ad54eee874027336fd24fe55abe5bc4efa9f02fd79c65988e7a9c4022"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cf8b118c1678f03de938cac644c8b9e51d47722bccc7ab42973fa3bbd6b1b90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68eaf91e63cc58938d125c0c13080a32c2c0d5996017e24154dd4b2d44875bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "37bfc3f28ff8824b6aebd77758c30e3265f03098df2e9547b39f131713a35747"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5c1551d71fc701e094c7797e48d3ac1ff4f67264c2ab1e5dbb27163718f7991"
    sha256 cellar: :any_skip_relocation, catalina:       "0e8d1081f654f988ca569a66c0cce7625fd9b31f8f1ea10ea14ebdb583efa660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766321b39a70a3394ff7d5033abefbfd2041f089097d294ab98ae770dce7d6f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,0
      second header,NULL,,,,,,,,,0
    EOS
  end
end
