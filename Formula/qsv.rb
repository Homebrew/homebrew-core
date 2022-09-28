class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.69.0.tar.gz"
  sha256 "8a4c29c4253afe2265349b735abe052c8c4e677572e4c1826117a51009cdec76"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0d122bd81be13ab4f62ebecb0306926e4e8c10cd2390619b8472d5c4a858fe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8ffff2db50702c1b1974b7b69e574234052bbdb8ae2c0b858fdc8d6f862716b"
    sha256 cellar: :any_skip_relocation, monterey:       "aeaf83d6b65d54f712516cc0bbd6944b784a9aa44856df76e9b4650cd2719ae2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a75f75b61abcb3f39e3beb40d17314ac127570618fad808e6ed9d7d91cd5bb7"
    sha256 cellar: :any_skip_relocation, catalina:       "e0c1fb9f712f80c1784065c9630592a5666fa441d6ec874524c2fb70649cbc70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f95774e009e718a17eb921003bc47c3dc7d27f5c612ef6a7970890a16f8d88"
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
