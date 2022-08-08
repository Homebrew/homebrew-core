class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.61.4.tar.gz"
  sha256 "d82093b4b3fbae9469000b1970c34ad31b9e59918f617ffab6d9ba5eb785e04a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9be57906a7ce34eb07bc91132ff4f8f16b091b9ad8d589a329f5b5ab7aac4ed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "740961233e539d920194a6237dbfc32eff6dd3555af6f88e141aff6d5a657c2f"
    sha256 cellar: :any_skip_relocation, monterey:       "db655676caa115ffc58d4fb35a97d11d3f1217965de3c2d827380701f5b60fc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd5d595df8a2c32082c5ee72d8623999fd575e70a311678f370762c12f2e5171"
    sha256 cellar: :any_skip_relocation, catalina:       "4bf59dd54dc8b00dd4d84b2226b88fb9a1aa95b73c31be75949e68033b3cb18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff5cd24f017213b36a0268b67f18f904ef5b80d37e1192aaaf3004bc28ef4c2"
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
