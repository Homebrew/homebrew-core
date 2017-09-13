class Vimpc < Formula
  desc "Ncurses based mpd client with vi like key bindings"
  homepage "https://sourceforge.net/projects/vimpc/"
  url "https://downloads.sourceforge.net/project/vimpc/Release%200.09.1/vimpc-0.09.1.tar.gz"
  sha256 "082fa9974e01bf563335ebf950b2f9bc129c0d05c0c15499f7827e8418306031"
  revision 1

  bottle do
    sha256 "b82c822bb057772a0edce2c5a8f61863efd130b682b67eae3c27c287674b3839" => :sierra
    sha256 "9114eadfce8e890ea003ef9ea763905dcd47e6a9dc72e8388071721ebabd1820" => :el_capitan
    sha256 "2cdc5fc0899ac53a35ae1e1ee99eb0e282750277a407699d37afe419068ffce3" => :yosemite
  end

  head do
    url "https://github.com/boysetsfrog/vimpc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build unless MacOS.version >= :mavericks
  depends_on "taglib"
  depends_on "libmpdclient"
  depends_on "pcre"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/vimpc", "-v"
  end
end
