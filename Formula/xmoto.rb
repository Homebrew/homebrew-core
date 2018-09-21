class Xmoto < Formula
  desc "2D motocross platform game"
  homepage "https://xmoto.tuxfamily.org/"
  url "https://download.tuxfamily.org/xmoto/xmoto/0.5.11/xmoto-0.5.11-src.tar.gz"
  sha256 "a584a6f9292b184686b72c78f16de4b82d5c5b72ad89e41912ff50d03eca26b2"
  revision 2

  bottle do
    sha256 "7bccb7306789c62b620ee83a0adf494744c96894eba69dd1536575cffb1f1a42" => :high_sierra
    sha256 "5b8e90cc8c4f88b7f189b5ef4d5e213af984bdb4ad6f378cdbbab0b7a2b5a462" => :sierra
    sha256 "42bfe9707509681912b5ab0d08d715edbc7d1b15f779a569e99e0edab26734cb" => :el_capitan
  end

  head do
    url "svn://svn.tuxfamily.org/svnroot/xmoto/xmoto/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libxdg-basedir"
  depends_on "libxml2"
  depends_on "lua@5.1"
  depends_on "ode"
  depends_on "sdl"
  depends_on "sdl_mixer"
  depends_on "sdl_net"
  depends_on "sdl_ttf"

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
