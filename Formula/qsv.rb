class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.107.0.tar.gz"
  sha256 "628b18a3ea9ebd0b5e82e3fd9db05348c0c6aa32b43b32bdd12c0217443d88be"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "860603cff248d4b5bd72715a73487a1c01c866adb180a4537464573e92365d17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a54f9284dc6304687a6ced91001f13f741905ba49beadc2d03b7be6bf6671352"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "923a9b4309db7ddb53c1f9cc448a01a710352b7ca03c7a7b8832f4679c9c18d0"
    sha256 cellar: :any_skip_relocation, ventura:        "3178410ec4009c2828b1a22fc9799035ada7c60c42a4f93a91fb8d143c5b26be"
    sha256 cellar: :any_skip_relocation, monterey:       "e8293d63ad010c0fb9b5c732f5b7e79bf6c93ad900cfee364ee5a23cc3358901"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a999dd928217532390f87ee89cd4d4ec2f2ea537583a0cb095dca5d0bb1f438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb948e8911437a66bd1765861df13fa0ce4e8f848a18c0f2bda02e4b72b7e6d0"
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
