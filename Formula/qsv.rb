class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.90.0.tar.gz"
  sha256 "62c6ec687a205053354a5f41c001e21c212aa47f6d9387c2414642e6a51a0d29"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb3cdfe089561c831ebfe5db55146aec3b7abc96ae02b7fd3dfe175747e47821"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3eb890925fdd3b7727b3cf38466072bc811188283877b7402957e57bc3d1832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f30200c082115a24560b897e5394a770e70cb4658b8e5f33937b88619e0ff5fc"
    sha256 cellar: :any_skip_relocation, ventura:        "90bf2f7125afc3b8811ec2b3cba52c7d50415db9368710fe9d4df3c41d73759c"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1ecc3e5293effc2a7c0271912c7e3b33a51f81e8b61480976b2fff27e8b9a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "94023f6d7712f6fded8323a14bb575b54b48c20fa524f418760e7ebe7991a6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45464b437f51f174a62f466a86739305af75299bd03639b21a79ce5e8d99a955"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
      second header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
    EOS
  end
end
