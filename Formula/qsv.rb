class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.60.0.tar.gz"
  sha256 "5699f7b5b56b6ca220c47e825557d08e90faa8209492e08c2829ddd9690136d4"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a7d72b0341421c16f08b8e4fa161e454c1310dc8750909504049cb0809f4b76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee8ca9e387f212936fe59f3319ecaade8f5690ffaeb2a011d3a7a565f820c1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "3ad2f0d1b79a22802a6b55f811b77fd355f9ef4315ecd2a1395460334d5bca65"
    sha256 cellar: :any_skip_relocation, big_sur:        "66455f85b8435b3f13b47f6f9b2a535a53fdeb046740daa0dada5546f754d611"
    sha256 cellar: :any_skip_relocation, catalina:       "4e704d527cdaf139bf4045b35c2ea5a27f281ffa4b52f44ee897bed198de2079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79702f33b074a082083ce8a34510aa6c75d532062eadd8c2cd4d6e70973cd1c5"
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
