class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.80.0.tar.gz"
  sha256 "d806762b3e95d2ceebf350c2c81696528a5f5d599e6c4da01328a963d1d9944e"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16451ebc0c7819d57dedb95765e6c6f94c5c8c9e2249a359f250bf5a57fc15d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "becdd96fbb67d6d21ca76b723e2c28ddb2fee8796e5d994e43f5be5f05315b73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8140d9dca648052ac6704c7c89d3055b0a046d36f16524417f86ed8fff90fdc1"
    sha256 cellar: :any_skip_relocation, ventura:        "41752a4a40a610521912df129ac6bdd04db7824a5b12755c12722c6192460db7"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e1ef9d30e1a0711573a5118f2af3bbd44b81ca7a3d35f3fbd6d95620c3bf95"
    sha256 cellar: :any_skip_relocation, big_sur:        "e46f1a4cdfcf6709286a8f785725eaf4d5549f5ac97155454f3f6016065e2e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6fa321c05b9b436de568e16861559d806150f89a8f95614b5e05c186a42df0"
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
