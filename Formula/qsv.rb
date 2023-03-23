class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.94.0.tar.gz"
  sha256 "1c105c0a8c24fadef245faadee9fd3e77b82342f438e0502df18624cf06fc4cc"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df746e8f3d4fb75c9266d3f10c42f05c2557501e84d2f14b9cab1280d011b31c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "357bb5905dd8820a7ba0597171172314f105186881159fcee52b27e75d5d62dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c080806073c025551f5fbbf030f1cad0a692669c0359a73dff48a203b588ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "2a46af4f89debafd6bf848d781037ec857e00acc6a39e03ce4a8c1b652ff38e4"
    sha256 cellar: :any_skip_relocation, monterey:       "36e1f2b2240aa20a701f079d419652cc82d7d041f39e75ad96311de34a919862"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ed67f590efc80c6f8b854f4ac683feba4d45d1331f8fd85abe4dc4d2c8cfd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "047a668cf921c41af3aad572148ab62d8f0c24efe7ab10f793ac2345abe29038"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,full"
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
