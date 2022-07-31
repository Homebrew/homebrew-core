class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.61.1.tar.gz"
  sha256 "ca7d93a83ea83b29762edfcf3863f08ac8f0ac83701cb8d251ff1ee5daa0287a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "895573b32d146acc21dedb1614e5fcd635fc9d7a1f984eb661b106f8877856e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcfb516c4a6d991ae64b9b998287bcd5a0d1707dbe3e007c4327a7c75c9d3d26"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5a92eca81b8c2b0dae5f9d08412e52b509a789ec6eaf261a16b35710464066"
    sha256 cellar: :any_skip_relocation, big_sur:        "1004678694e8727b3b5b83a90eac6ae7a9d453db79bfb1d41cbb1317accb7862"
    sha256 cellar: :any_skip_relocation, catalina:       "44b3b1f3c6f7a7a37b69e595441d87628aa0237cb9b43987e347874b0efc97a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac441c9fcca2244896ae9a757a546be43874acd10520a859760d4c3d8e4611c"
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
