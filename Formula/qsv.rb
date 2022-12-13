class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.78.2.tar.gz"
  sha256 "d41f8ab0d66c89b65d99605743b172ed94bd7bfa973cf4af220a9bdaf3b08ed9"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4648cebbe75b1ca8c2a69ac6401b06458832db803702be2a3c0dd3bbb02bcb50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06a928badac95b7e01aa33ed0221ac9fec4427139034ee05133b3b80b6097b39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85099b7731a179be3c781a6b471fdc58c82082fbe9c2122bb3e185d8d7cd2c6b"
    sha256 cellar: :any_skip_relocation, ventura:        "e895c7dfdb9b190875b903b60835d712bf6d0d04987dc8d07f06ce4d92d81f73"
    sha256 cellar: :any_skip_relocation, monterey:       "889c394660c2ed112b48ee5805e1cde96e240fb42c2d6f937725901565de15c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee187ffac95fd8a3d56246a7ff7ede6a2cbcec051c61ae71fecb0d299bbcd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2178b735e8e92ea636ce7eea59d373b2b8ab2ad58ae7578f4c025c4773490723"
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
