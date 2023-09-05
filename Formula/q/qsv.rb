class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.112.0.tar.gz"
  sha256 "f8f32939e1a631e3b611cfb841a86ec376fdca66c3cca6edb923650634a727e6"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d225d372d5eec7affbf0ffd5d216e5c7c7f9fd2809b58ddadb3937881f7d1664"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ab0fb5ff33ab95c144760dd748bb13aebeb8dc26798db135434c860a20c8af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "274a31cc85f85844a743e519ad6a2a184d423fe6c9a82acf56e3a1ddc0d806bb"
    sha256 cellar: :any_skip_relocation, ventura:        "f4a8339a82b744fe798afe87e93c331cf6a30d9a0eb9659b6f7194a991f98fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "971ebf7677347537b3d20f753306c1dbdc4bcf1c69f303d3d5fd61cda6ebd833"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5aba7176fbfe2ff98665fc31b4e4645bd714daf9218abbf282104aa8f43d66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f45bed4e661233ae36fecd05c9beaa20827b2078abf479dea2ec68f1a1f5758"
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
