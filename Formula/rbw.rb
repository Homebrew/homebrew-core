class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.6.0.tar.gz"
  sha256 "1917e79d9fe7142ca82919a5ed1cac50ca719c21e927d5c2e66ecb21d69e03aa"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65787990344ad50e56b1e2ebd01bfd1189137390f07f0c74dceefa60177a92c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31f133a332c33a9a8e24daca17e93ee41629674457cdf63bb1591d3a42c910a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15ddda21b252ab60baab88e4b7cac159d5f8dd864a4f0ef7f6bd20fbd8cb62b2"
    sha256 cellar: :any_skip_relocation, ventura:        "25d74a307cc178fd5cecd94fc7f387ce896cec09cbb5a93fc0063b13459d3d34"
    sha256 cellar: :any_skip_relocation, monterey:       "aafdb20404a9de31f4c7a495f56642cfa4e85db5a45555303e6f32831830b251"
    sha256 cellar: :any_skip_relocation, big_sur:        "81ea16cddd89760ac3096cccdde10d8238013ba571a824a01e2ee3793ef43b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0d7c1cc5b3f76b5de4afdc18183a108c3ed3555b391e83637a1d114ad4d70d"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
