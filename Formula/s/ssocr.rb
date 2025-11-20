class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.25.1.tar.bz2"
  sha256 "e7588bb9ec56b568362ca0b68c216b0af37b42bb3f63602ee21628aa731b84be"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ssocr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0f42e28996a17b2e29066ce478aca92a85073aeb25ab328ff67df768c825dd4"
    sha256 cellar: :any,                 arm64_sequoia: "1f276c84ac527ad48c93f5f7a9976d65b0a25e8a06f942966f9dde044d20a279"
    sha256 cellar: :any,                 arm64_sonoma:  "ab621788f03af63c93a917b233bc96ac1059cab8f64d5befb01bd58efd05b597"
    sha256 cellar: :any,                 sonoma:        "a839b147d3dfe88937947728b7bb457ae0eac4e43d1bbbafcbd90f7b3e43b6b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c868a5ce5a5b44248c6c7868b504d0b0243ed1b9b39b4a0a4ba929bfe56f1aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b91a1ea88a60fa5037e2533228a0c489fb40cf4ca1d55a67b4fd03bd8c7b580"
  end

  depends_on "pkgconf" => :build
  depends_on "imlib2"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource "homebrew-test-image" do
      url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
      sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
    end

    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end
