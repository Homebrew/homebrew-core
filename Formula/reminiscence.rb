class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.3.4.tar.bz2"
  sha256 "d389fe2fc4ec151dc072aac98c94333972c0cd37d9109994bc845167074e3913"

  bottle do
    cellar :any
    sha256 "7eef70a73cb617c1ce9cd25b498634633025e9b5f653c4759993b00ea57afa31" => :high_sierra
    sha256 "062ba9c02ce35d463119df045dda6484dbfb09f853dcebef6cc5bed42991f1d2" => :sierra
    sha256 "83ceaab9230a493bd1c86d1db0c9b4fa77070c0cc495339006852781d69aac9d" => :el_capitan
    sha256 "ca207b017eebbf2b7e9aca765f2c73aadef3a1f66b602e67189f1b8534e91c11" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "sdl2"

  resource "tremor" do
    url "https://git.xiph.org/tremor.git",
        :revision => "b56ffce0c0773ec5ca04c466bc00b1bbcaf65aef"
  end

  def install
    resource("tremor").stage do
      system "autoreconf", "-fiv"
      system "./configure", "--disable-dependency-tracking",
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
