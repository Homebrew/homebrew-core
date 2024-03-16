class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.124.1.tar.gz"
  sha256 "53cc01abf04251a48df9b2237a65aa477cabaadb43359fde8260a213400ff920"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe1989ec44b2e4aa7278ccf882f8db85c8f5c9ff69d3a435448477c6977a3f6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "310bd435daaec96da4f0044c8959be3a1ecfd15d40bfb2341890b0ecd270a007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94ba4421f8b7e1e884dc1a6572baae5b28d0cee7b1259bec7d1800e940427c40"
    sha256 cellar: :any_skip_relocation, sonoma:         "1521ef137c35ef18826516ec2fe6609c2b3aa19817979df56ac3dbbd012d0dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "24b9598677098d983f2330ca74727bdea72eb11f1893231a8d5b9e0232d7aba8"
    sha256 cellar: :any_skip_relocation, monterey:       "0e402d927123e0fd2d3016010903ae639ede61705c45e11c9e1bb06d8f56f14f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3388757b989775cb985ded4014caf55e06c35994200ca55737cc2f5021dc66f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
