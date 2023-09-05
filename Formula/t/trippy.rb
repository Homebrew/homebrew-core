class Trippy < Formula
  desc "Network diagnostic tool, inspired by mtr"
  homepage "https://trippy.cli.rs/"
  url "https://github.com/fujiapple852/trippy/archive/refs/tags/0.8.0.tar.gz"
  sha256 "4b2155ca20d53ee1d29c9459a6efc4ee094658e93033a90085e39c841d02666b"
  license "Apache-2.0"
  head "https://github.com/fujiapple852/trippy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca7942839c96151fee0e2abcc7d5b551fd53c75f797a96b786e11316d04baaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f0ea6d43dfa05b6bdda735eb6dfac2f3e38b99f4a09694929742633fbc12f47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b083e2f4d9afd3c82e2d1b2e01f52e6804972e4205818c0049f6e39ea688608"
    sha256 cellar: :any_skip_relocation, ventura:        "48e6cbda0b86865439925bd439e128b120e675ca97abf0798b9d3c4d83b9eefb"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4ce67bbe64a8cdda172993c16b9e74a08ef0ce094c9d8425b845108a1cb0e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "452cbfe0a5557e9b8b2079bb61496d0e45f3bb0c9179873c709d0f472033be26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d134c0706c4f73e14a541865d16968e9c86ce81f2bb48a17ebf428316c08b281"
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

    assert_match "trip #{version}", shell_output("#{bin}/trip --version")
  end
end
