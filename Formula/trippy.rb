class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.6.0.tar.gz"
  sha256 "4da57c19f4b6a6f3b4426ea066278ad0b0df2d2addae548b839a17fb20c464ae"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2030a008abb4ca629575950baf3f85e16e73467f8e428856863b40b752470cf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e62b81b6f2efef41be2d52f774c5d9f79bf82fbb71c809b258cfc7d473ebe80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6f01b1d42ae40744a7332f424e63a897995c4886c45fb91c2fbd6d1a7b2e7d7"
    sha256 cellar: :any_skip_relocation, ventura:        "57131065ec3b2ed98dfcb62253d6ed5d748442628b965fbd0f2ddb0f6e0e934a"
    sha256 cellar: :any_skip_relocation, monterey:       "8a3601839b0c81541f899b97e4421d0d08a00f987c772fa13f5f8f20ea4df608"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d6cca69634123692f57c87aa3b558a08f6681b1f8dc34092674f919e079cdb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed0b1ee7d4d7ed1f8bfa7a52e92a97c0f45c4d54c175e506f444c697991c797"
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
