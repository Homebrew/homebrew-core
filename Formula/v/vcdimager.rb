class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftpmirror.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"
  license "GPL-2.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4fc5cf3e045233757dcf29a78fb731148d3c5ce9692df7825024b0b3ae66619e"
    sha256 cellar: :any,                 arm64_sequoia: "2dbaab4b58479eca7337c3648f97c5f77bb8fb2ee40fd065b931215a16d52330"
    sha256 cellar: :any,                 arm64_sonoma:  "3b3614dbce9b743fb1f7e31e2dfdd0a59ac7949277c5fb712c09d0fbdef0751d"
    sha256 cellar: :any,                 arm64_ventura: "826dc8ca62806a582b3f6380e63c459e7f720a4a1d038fd9a3e9ddd0b6b0e260"
    sha256 cellar: :any,                 sonoma:        "ead756089657c553a3d6e6f0fe321aa4075743698b15525101fcd6196bd1584f"
    sha256 cellar: :any,                 ventura:       "418377dbcee1226a016018065deea7a062aff9dd367fc04af9ddd58ada1307a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ea9d3fa898a61767152f2a7fbdddc2375a42a10b24b7c38542d509d760bc7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0352ab14296e214d729962fb5c50eb822c7abcacede083e5107c273a908fbaee"
  end

  depends_on "pkgconf" => :build
  depends_on "libcdio"
  depends_on "popt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
