class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.67.0.tar.gz"
  sha256 "1eb5ed429a10606d1e6441aa7ba10eeff37b1d5691bf856db89e3152ef718ea1"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69a90b511a08125ae5a0ffcd539117d871f53e4a6f80a4b1b60cec20c8fa0153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "565134c51a54211857f30575ce08f471409353a6b0766d85ee9f9658ebb72615"
    sha256 cellar: :any_skip_relocation, monterey:       "4b8bbaa08b8d278d0e63548bc2a514f0f51d5fb105275a4c2049680e67ad643c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d755fd751ae2aaeb4b9dde89d12f54cc4494cc114ebfa92a35043df16b495db"
    sha256 cellar: :any_skip_relocation, catalina:       "3ede0b22783e23348e28dca46b98c1a0c282c8147307bbe2e35f609bfd9424ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e833769824791014e05a5f976abf867fa63ac0a4cc49034a16b9adb66698d7"
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
