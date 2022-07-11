class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/0.58.2.tar.gz"
  sha256 "9bc0a6763805dcfd7ebcd3e26c61444e4992c50b01cd12a30f9bee147b82e8b0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ecd07b6f8e465a8f35a44bb21ca27a6f02db6b21e12f6e773e8985f11996ddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c1a61cebb3a44a8ff8a81ab38a0bacf6e1480538c9672ddd659317196edbb95"
    sha256 cellar: :any_skip_relocation, monterey:       "46d0d39ff49a402e4c5683dde2a00b06a5dfe5956c6f92eb4bc0f23d2439dc7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb2f189daec3df313eb18639d8eeec1c48a61e69265453fd14dbcf741124257"
    sha256 cellar: :any_skip_relocation, catalina:       "4aa37839e5de957b5f4b880bf57f4968ec54f56314f85b751198faa246896cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7e2d1e5c8474c78b959fe838a2cd556ca52175203d942934d15c3e88ab8c8a7"
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
