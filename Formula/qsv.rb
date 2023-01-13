class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.83.0.tar.gz"
  sha256 "588ec7603e16a7fc3d00bd2e78465837c4cdf2fbd0fc648ef6196138640b17b5"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c93cf4a66dcb8c6b19ed3f7b8320881204171a29bc51f8f714086cbbc07a2106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d3ed679b3df305e44b01215f06bf4a5e43468a098e106811fceee2345d25589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed650115497a5ef29e691cd044d555a8960805372b189f975196824e732ae82a"
    sha256 cellar: :any_skip_relocation, ventura:        "1421baabae2bf163f64d04531a1bdb37f0195880a9eeb16573557bd22a424921"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d1945ba159b3335762a43651689d695cc41f1cfd0c88777796031b7cb9e9ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea7a86af5a5be12bc1a1175597e7aee7daba1251a58d2b792c2e046d316ddef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cef85bf8fb1f7029f98efc1cb8f5717a19d84cc42d0c4ce9d9d71d985043204f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,NaN
      second header,NULL,,,,,,,,,,0,NaN
    EOS
  end
end
