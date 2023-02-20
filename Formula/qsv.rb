class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.89.0.tar.gz"
  sha256 "88b2d23671cea6bb24a812fa137ae735e51e9fb6437cd0cc682daf62ef53d6b8"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0662d3ba118728e45270c618f068bfe77f45b306f67cdd4f1643bb43e165a2d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3faae113f50a97a51b2698a243b4543e6f0109fb88aabe7c30591a0aac4db461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5b5468034f768979a601fa00024c7b1f0b0aa0a1afc8c92640a7ac382180d27"
    sha256 cellar: :any_skip_relocation, ventura:        "06de7de8b51ebdf145e36d3dd2820fdc6a7936cc9c1bd9e306e2902c6e621977"
    sha256 cellar: :any_skip_relocation, monterey:       "dae2948d95370c6ee8a9cba4f4ed6aab7709c96c368170415bf3a3059dad32c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "379c01f4b4dfca428951c5c59b45273cfee83b0ac9646a68d99d5b1f53e1db15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11ede71d9a9325e475c1ecc81d28d7a2ce94508b144dc8a0eac468394cf38987"
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
