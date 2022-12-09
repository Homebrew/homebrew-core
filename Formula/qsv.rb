class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.77.0.tar.gz"
  sha256 "fa31283b1b1e3186853f56f363f9525ac81664d432b29f3fe2e15e134e755b27"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0741df1fc1bc2e8fb44c8ccae33c8c90dd94e6f61baa9123db29273b69ce5557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fcf202690ec3bfbbb4b6244c18e84500df388240efe05ee8d9c674adbc7c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f846e73cedc984e694d8d78568c48824f3d65a69658603ddd0706e7131623c6"
    sha256 cellar: :any_skip_relocation, ventura:        "90797fabe8d26b6201594e77e98fe7370288bf30a352a8832e7e25c9efd38d71"
    sha256 cellar: :any_skip_relocation, monterey:       "30296a7622c12c1648a138433c959b8619033f5b850534fc6f3f256e0301189f"
    sha256 cellar: :any_skip_relocation, big_sur:        "57036dd6add14ed4502deb233fb10a5993529c1b32d52a54a128c786ab4a9749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6ebfc83e90a6770fd7b4fb6c40b9937ca0d45f5d3e3a477ec8fef5e1508d50"
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
