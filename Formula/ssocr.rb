class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.23.0.tar.bz2"
  sha256 "ef7f6037943fd84159327289613173114115bb2d9cb364ac4e971c90724188d3"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "595229e2e82a898fdbb2b9ff2ab0a730f5e81f6598f438f5ed41c00c33b1c140"
    sha256 cellar: :any,                 arm64_monterey: "4f5bdc8fffb4ae23410830b9967c188298da3ff2b51c3942abd91ff313ebd0fd"
    sha256 cellar: :any,                 arm64_big_sur:  "4664d9ffef8695c0aa988ab75094e5a130c2fcb02a8db1ff9071adfaf5daacf3"
    sha256 cellar: :any,                 ventura:        "dc56506df8b4e74ec4d502894a0c258d1bb2969dd0f0f6f6058fa266af409b71"
    sha256 cellar: :any,                 monterey:       "deca9a3828979d116fdcdbd81d06d78a57298150509ada6345853d74f3717be4"
    sha256 cellar: :any,                 big_sur:        "f72206f52e36bb13cc1cf45d48f61644af7d70e0b5924b567c395bde9ab2e02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dddaf234241b22ca13714cb3f3e7cf1206f837629ef68d1836015de8bef1250a"
  end

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end
