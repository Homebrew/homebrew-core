class Xmoto < Formula
  desc "2D motocross platform game"
  homepage "https://xmoto.tuxfamily.org/"
  url "https://download.tuxfamily.org/xmoto/xmoto/0.5.11/xmoto-0.5.11-src.tar.gz"
  sha256 "a584a6f9292b184686b72c78f16de4b82d5c5b72ad89e41912ff50d03eca26b2"

  bottle do
    sha256 "d0beb0f81e97e0495fd012a01865a3a14fe9649077dbea2b91a660e90dd77248" => :sierra
    sha256 "350e2da36abf8fff00315730804f996f19693e35abaf9575fe0695db2266a60c" => :el_capitan
    sha256 "6f75a5d9669357094f10beaefedf52819c9a8a525a876ddb51d27f5f77e2fe07" => :yosemite
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
  depends_on "lua" => :recommended

  def install
    # Fix issues reported upstream
    # https://todo.xmoto.tuxfamily.org/index.php?do=details&task_id=812

    # Set up single precision ODE
    ENV.append_to_cflags "-DdSINGLE"

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
