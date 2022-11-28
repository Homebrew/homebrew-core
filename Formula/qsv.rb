class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.74.0.tar.gz"
  sha256 "c7675d6dcfdcf85d59394cd57772c417ef48c31d9133c25828a9d3ec6bfbb277"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "031324e12524831bd941f65fc482738cc1e20e7d80d8b76e7ea1bf23951d520d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb794cbec7e0dcbf0047469e06dc98864638cf495f600d0ebaa99991408ed5dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd08e4d7a9e648ac4fe2fb5b4a8574924117e9d5edb29ef2cc62138acdb20c3b"
    sha256 cellar: :any_skip_relocation, monterey:       "70da383616cbe3f2619b6a5cd506467b7beb5c3023f4f54b6752195a403d19ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fc8b89414e424e9678b24636354cafe98ef36717a12f57f6c23383354ad4649"
    sha256 cellar: :any_skip_relocation, catalina:       "b3f8d11eaaa47cd0c3181234c66a44da2a852e1534f479c5f11ff5bb4a80bd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6648f27eb921d99bf0366928d80e583e45ad4545abfcf6a2c594011fda13a4"
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
