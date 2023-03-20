class Zet < Formula
  desc "CLI utility to find the union, intersection, and set difference of files"
  homepage "https://github.com/yarrow/zet"
  url "https://github.com/yarrow/zet/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "09480557797737155edee62c58dd02a7f634d351ea67d02aeb351bace75786bc"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc228722ba580240273282e8618e7fb03f2eca3b542c05e7321dc37678224cba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5fa2a07d6bc08e8048c5083dc4ef39633372189325477e5272a065667fa851"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ef9baabbc9a1446583e09deb230a26996fc5431b0c556bfdb3f851322db324"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb210bff369139d32fcf561352eb6d281dc024fcbcfc4f57264574047d3a48a"
    sha256 cellar: :any_skip_relocation, monterey:       "ad97379bda46051f9f77395d2e41491e81c3c412e8cffbe1f59f9c172947dd68"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2783c89bf1a10e478e9b29df84207533afc9a01d58cd76dab0051942c273471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d29ead5c171aa3741bf3728ae929705df5d1987570b08f928e6575af745bf6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo.txt").write("1\n2\n3\n4\n5\n")
    (testpath/"bar.txt").write("1\n2\n4\n")
    assert_equal "3\n5\n", shell_output("#{bin}/zet diff foo.txt bar.txt")
  end
end
