class Xmoto < Formula
  desc "2D motocross platform game"
  homepage "https://xmoto.tuxfamily.org/"
  url "https://download.tuxfamily.org/xmoto/xmoto/0.5.11/xmoto-0.5.11-src.tar.gz"
  sha256 "a584a6f9292b184686b72c78f16de4b82d5c5b72ad89e41912ff50d03eca26b2"
  revision 2

  bottle do
    sha256 "20a517e3d7bebd503836a7f7cb4619b091e8a968b312be86098c5b385df592e3" => :high_sierra
    sha256 "62e3615560cb27578c0cced98e412c45ce7c936719b4281f1dc39d2b33d3d771" => :sierra
    sha256 "5cb956846ea6f580b9ea5e5b1b906cee31dc563991c1bddae9c2c338040a3af3" => :el_capitan
    sha256 "d9e6fc1564f7c0e6533824268d4782f670965428c7dd1247a3e50686a7bf535d" => :yosemite
  end

  head do
    url "svn://svn.tuxfamily.org/svnroot/xmoto/xmoto/trunk"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_net"
  depends_on "sdl_ttf"
  depends_on "ode"
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "gettext" => :recommended
  depends_on "libxdg-basedir"
  depends_on "lua@5.1" => :recommended

  deprecated_option "without-lua" => "without-lua@5.1"

  def install
    # Fix issues reported upstream
    # https://todo.xmoto.tuxfamily.org/index.php?do=details&task_id=812

    # Set up single precision ODE
    ENV.append_to_cflags "-DdSINGLE"

    ENV.prepend "CPPFLAGS", "-I#{Formula["lua@5.1"].opt_include}/lua-5.1"
    ENV.append "LDFLAGS", "-L#{Formula["lua@5.1"].opt_lib} -llua.5.1"

    # Use same type as Apple OpenGL.framework
    inreplace "src/glext.h", "unsigned int GLhandleARB", "void *GLhandleARB"

    # Handle quirks of C++ hash_map
    inreplace "src/include/xm_hashmap.h" do |s|
      if build.head?
        s.gsub! "tr1/", ""
        s.gsub! "::tr1", ""
      else
        s.gsub! "s2) {", "s2) const {"
      end
    end

    system "./bootstrap" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-xmltest",
                          "--disable-sdltest",
                          "--with-apple-opengl-framework",
                          "--with-asian-ttf-file="
    system "make", "install"
  end

  test do
    system "#{bin}/xmoto", "-h"
  end
end
