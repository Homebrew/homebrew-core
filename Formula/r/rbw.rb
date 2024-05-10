class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.10.1.tar.gz"
  sha256 "0642bc7b0b68a4570097ba36884595eb2e29622565c24557b99d59c5ddf1bb87"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bcea2fe005c224bf4c345fea27a9c1634ec07286f421071703d554fd5c4f5c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f85631b6c6c09c53b299a1d700395927f5981a9671453eb6f5cd59dd0340beb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3edec3bf061841b872f8313620dec2a63051d8698dff1c3b64d5b925bd9d7d38"
    sha256 cellar: :any_skip_relocation, sonoma:         "3161479ff02d1b40583aea8c0c90171d2016f1e3d25169044fea9f94d8e57f35"
    sha256 cellar: :any_skip_relocation, ventura:        "6678b622e921418227b47e8e28b81819b03dac9ee2c259f15ef123ed782aed9b"
    sha256 cellar: :any_skip_relocation, monterey:       "21c7b8b6e1404f2b5cc42e389ccaf2626a9e44abcbe82137361e32a19e36d228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7af00f816272a86206d0cf238370595a3ed6659079cf2ed592d95369586b85be"
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
