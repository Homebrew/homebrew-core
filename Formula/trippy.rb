class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.7.0.tar.gz"
  sha256 "a3fa2902fd062516011d733def61941f867da3f9d6b84743ba4eff631bf8db18"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15179c047513335a4695a77896ae34584f67916e8e576d5015b4a41cf766f8db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeb0090edc2f0e713bc96f12e35ff3ced5b169becf66ad6400483315b1a0250f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19b7889aabee0b0c8ac0de285a3b8c7e0b57d5ca3b14f1736d7ae725a965db5b"
    sha256 cellar: :any_skip_relocation, ventura:        "9510816930c84d961cb26234a5165da01dbfc053ea61fcd799315412eecaebb5"
    sha256 cellar: :any_skip_relocation, monterey:       "2c855cca769f588c3b7d6f7cc44a04d2441a079f0b7872507d8fc1b602222ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "94f1a34fa28692b4490584dd9a33e875ef9ece5997d3ab7c2fb53fa904cf622e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f4d48269f2cd658aff81584de69674205cd59f7d1b4295d60cb2e25c72589ca"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # https://github.com/fujiapple852/trippy#privileges
    expected = if OS.mac?
      "root user required to use raw sockets"
    else
      "capability CAP_NET_RAW is required"
    end

    output = shell_output("#{bin}/trip brew.sh 2>&1", 255)
    assert_match expected, output

    assert_match "trippy #{version}", shell_output("#{bin}/trip --version")
  end
end
