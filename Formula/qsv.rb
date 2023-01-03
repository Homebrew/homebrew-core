class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.81.0.tar.gz"
  sha256 "c7e74827f4800df747097e0d6538e6cfc15011393ef57aef827589afb5f7d5a3"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed59f494de8c99efe0a97f0f8f9d08b416e4f5430e384bb9f62795e4fe8e5daf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3850f2c8630124bbf09e1b194e7bf05d86c1ea5876d7c7c45bdb62235f1b4a16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce5271cfc8f8d6c91fb275a4c15032eb6a38abbdfa3907005ad2303434538ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "2e2a47895191b877ae6312dbe3051e02cc676f89b548ffd78d125fa9875663f6"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2479b4b7f093888e6da229b23617f52f704cfd9c6fa8d2ff03b4719af6b444"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5e38a01b2165624d3d2ba8c4a40cdd31d60a6da75ec056b67ba574e8af7ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86970faaba26ddaecec4b9d4f9039e51e813d99b11faa380e3cc729094bfecc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount
      first header,NULL,,,,,,,,,,0
      second header,NULL,,,,,,,,,,0
    EOS
  end
end
