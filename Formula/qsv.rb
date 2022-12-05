class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.76.3.tar.gz"
  sha256 "d0f5a0d93655da24fd35cb27c64963842a8ec71d34ba9650417a70ad90bd6ebe"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aa160e091e9f4737eadbc7e4fc9d62fd7b15b11f526576e5393efa0846d57db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d65c09bbcb9a76817f84d8660b92c485a220ee05e4c93b1eb795fed7fc34f8a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7dadfdd7c35860ab09c9ea9f31d864a3e93a886e58852988278566d56cc6775"
    sha256 cellar: :any_skip_relocation, ventura:        "bc87f6fea92dc75edea14c0ec25a8ef4c28121e97a761bb404330eeef78baf81"
    sha256 cellar: :any_skip_relocation, monterey:       "afd5916938cbfdfd3a2f78146a26e7ee8c637237bf3a308e1f2cc9e08eb1174c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9d2462a999a7d7ba440a74f8dc05311bc3249e29653479156a7b3cc0b93dbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a907ee73da262c74667b5a7bb295f89ae7cf8f616a66713ebf7de74212984d6e"
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
