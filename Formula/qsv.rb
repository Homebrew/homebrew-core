class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.65.0.tar.gz"
  sha256 "789e09499cb9b74314f0ee54dc399822b099b8590b3bb82f658b1feb405e9510"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0864bf5b0c256431dc8ec8376f643ec6016d96ad046241b59c624197c990d0a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e109977daddf1066f2a80959f1b12ea55b91a8b1d466135017f972c947f788"
    sha256 cellar: :any_skip_relocation, monterey:       "c768bf342f822e5a8fe44485fe56ec25027786547b6b469b19b56b96d2a27e2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3039923955a29c0f80f32028ef20ce8d3b713cd68f720e73b519c194dbdd3407"
    sha256 cellar: :any_skip_relocation, catalina:       "651f4e13f4e13d5e373551bbfb1b6ef30019c29e6c59f0700fde67bebf8576d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c416d622c6db172313b98c414b0b404b1afc338c2f00988500091680de036e2"
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
