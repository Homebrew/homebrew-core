class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.99.0.tar.gz"
  sha256 "93dd13d7679657701104740468a353cb85ae49935aedda4b566df30cd8d9bcaf"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d688ebdc34aa7acf42a0e8156bca00d5618150fd950b9e1a29cbd77ef7e976fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "203ab093c07dc911b62833ac4f03dadc4e2e563ca79ab3befb3cd7726b3f5b77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7fb985e6c37ab07a14e86f99f794ef73752893a43437b796b8d591242896e9d"
    sha256 cellar: :any_skip_relocation, ventura:        "9414f478e965e692a9bfdf2c149d6b254efa617dd6a8b60be80b3478c908a618"
    sha256 cellar: :any_skip_relocation, monterey:       "ccdfb86986641fdcdb5bcc1a68d3058636b49b6ecbbbde6d780f2f89795db2c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "350fbc5da32af783ecb290ac2726c27ab020f2c06befb1781947d21c06fdb2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea5e41d1bad3e486bfb6f1f6082d07cfc140316038b12689f31327a89a993fd8"
  end

  depends_on "rust" => :build

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
