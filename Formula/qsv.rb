class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.95.1.tar.gz"
  sha256 "38bedb77849867e9689870074351642e6027dce38aa2be41443d494b11218f91"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19ff7adf47dc72d9a2e1cb11334f1330ae5586ab9cd81a59826474d1392ff372"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec0613780d3aec25a9e859523434ed60db0b86feb31a3dd709b60f2f0fdd74d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eecc4f909e515c548d89e1797f6fa40f4202dc126fa9f6e314544f606397e3c"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d2e2f1cc8b526c2288a293a82148c865e189771db9de0a90ffc8868ada2580"
    sha256 cellar: :any_skip_relocation, monterey:       "780780039fe0a07cd092731bd09af8eb3beaaefe374c0918e73cb5c35f5aadbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dbd6452c9f5bb4af47a4d44c24de57f02b84d2e19ad139b58866131a989670e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7d6793e27a1687449705df1175ef1500f09f7a0c0664c0299fbd17747ee2002"
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
