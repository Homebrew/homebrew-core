class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.6.tar.bz2"
  sha256 "a1738ca7df64cd34e75a0ada3110e70ed495260fda813bc9d8722b521fc6fee0"

  bottle do
    cellar :any
    sha256 "08914eb6ff7af4b482d75d78f69b0d9b8f30df76bef4cd04e88ddc4e457d6b38" => :catalina
    sha256 "a56001c98f255e684babd5ddbcb28e36ed8699c559730f28fc3939edcdb25a5e" => :mojave
    sha256 "f6f27f326bb5020cced4c0e1c42f6f4638bfe05092440b51fd8257a1ce9e5288" => :high_sierra
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
    url "https://git.xiph.org/tremor.git",
        :revision => "7c30a66346199f3f09017a09567c6c8a3a0eedc8"
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
