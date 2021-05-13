class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.7.tar.bz2"
  sha256 "ef06d6230f9cae55177777713ccac5d2bb4913f075d0b964d593e41e22612874"

  livecheck do
    url :homepage
    regex(/href=.*?REminiscence[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "b29f5b37b68bbdf1d9e5b0b067d572e4b75cf0bd487c131248cf9f1de062b238"
    sha256 cellar: :any, big_sur:       "154c213b923be7d8ba32f9b6b39d08da52c8c4528c747616928bb4a32f7f4f78"
    sha256 cellar: :any, catalina:      "a587449c5846115b5bb4100e1ec50af6256e48bc770c35dad4985850ab8e1b3c"
    sha256 cellar: :any, mojave:        "a1a752e53d40822409ea80a273b38d307e6e6afdfc52d856dee8e8dcc6ae32d8"
    sha256 cellar: :any, high_sierra:   "537b631728a9b8e322cc835d20b3d8bac832c5c14ebc0bdedde43fe0b607bcd2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  uses_from_macos "zlib"

  resource "tremor" do
    url "https://gitlab.xiph.org/xiph/tremor.git",
        revision: "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
  end

  def install
    resource("tremor").stage do
      system "./autogen.sh", "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{libexec}",
                             "--disable-static"
      system "make", "install"
    end

    ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
    ENV.prepend "LDFLAGS", "-L#{libexec}/lib"

    system "make"
    bin.install "rs" => "reminiscence"
  end

  test do
    system bin/"reminiscence", "--help"
  end
end
