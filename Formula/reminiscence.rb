class Reminiscence < Formula
  desc "Flashback engine reimplementation"
  homepage "http://cyxdown.free.fr/reminiscence/"
  url "http://cyxdown.free.fr/reminiscence/REminiscence-0.4.5.tar.bz2"
  sha256 "108ec26b71539a0697eff97498c31a26a10278892649584531732a0df0472abf"

  bottle do
    cellar :any
    sha256 "fb9ac602c0bf9afe43287302a18e9a47d3cc27f2ef894fbfce60a90594e750ad" => :catalina
    sha256 "165e1694ef3880e68eecb99e1288fc7aa3d31d54cd15240757aa60292c479bda" => :mojave
    sha256 "b991cb2fbd838085444fe0267b352b9cce450892aa0982e3a5166ce2bfcc0cff" => :high_sierra
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

    # fix for files missing from archive, reported upstream via email
    inreplace "Makefile" do |s|
      s.gsub! "-DUSE_STATIC_SCALER", ""
      s.gsub! "SCALERS :=", "#SCALERS :="
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
