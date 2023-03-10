class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.6.0.tar.gz"
  sha256 "1917e79d9fe7142ca82919a5ed1cac50ca719c21e927d5c2e66ecb21d69e03aa"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2157af98332b6876240c0e9b0e07d04b6cb3c4afed87d261fe9c136f89522b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f29f5d5eafa33cd5d54df675381acc4a711bbf07591e366b30fa7ff7e769ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "633d71b1f795f796574a93bfc4d227c3e516bdc2ce3b515cf2d060c51904b69c"
    sha256 cellar: :any_skip_relocation, ventura:        "dc14547d19ff9c12a29a1d56989f275fbbdfb280380f7cb65f94b5604a528f64"
    sha256 cellar: :any_skip_relocation, monterey:       "8fabe80bbfa314f556400c99efcd75754bcc94c6e0bae21c7dc7ced469180bf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae1c4515036618c18575f69be55a4f876d0591d16c42394d990ac92da0a4d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b102f7c4a752ad30beb409c4814e74330136a22b172f4b923df1609b561bc906"
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
