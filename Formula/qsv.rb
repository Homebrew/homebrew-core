class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.67.0.tar.gz"
  sha256 "1eb5ed429a10606d1e6441aa7ba10eeff37b1d5691bf856db89e3152ef718ea1"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68a0a70f50e8ce7ecac2082562cb165befe569d0d971b3655ec6e1af73bc170a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d61a34988fff29176b9134d1ac94757ad423b436dde96f295a9f67c454d1ea7c"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd3c08f6211987a83ccbf0094ba5a1deb1a35a42026823d425043e06abdd244"
    sha256 cellar: :any_skip_relocation, big_sur:        "af343272d38c9b7ee81a3a2a2eb6abfa730763ec792250ce1e7a8d31b40ba1f1"
    sha256 cellar: :any_skip_relocation, catalina:       "e90d74f7e074ee320f6c0cdcf48fcba90dc14f4d7fdf937581aa154cf6325ef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "301dbfc61affe9e0a061c990c647bd290adf908b2a2b70316abce3eaf81a360a"
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
