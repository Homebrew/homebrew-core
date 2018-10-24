class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_0_4_5/", :revision => "399"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6e826bd49ceb171cc36877c0498d8ccfc3c614f39b684728e0c307b69942d58c" => :mojave
    sha256 "2779c8aba2aed376076e53fc9e2e694e8b5fabca0096ae91eed786b73ef3704f" => :high_sierra
    sha256 "9ac1a1c83a9861b8762ab711d709e67bf020204fb1c1b5907b244d83ced4ab2c" => :sierra
    sha256 "a4bf36f39959150e1f0cd83c8f58761ce59acdee50f591a1f695665b7517728a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl-prefix=#{Formula["sdl"].opt_prefix}
      --disable-dependency-tracking
      --disable-debug
      --disable-gtk-player
      --disable-gtktest
      --disable-opengl-player
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    # Install script is not +x by default for some reason
    chmod 0755, "./install-sh"
    system "make", "install"

    # Not present since we do not build with gtk+
    rm_f "#{man1}/gtv.1"
  end

  test do
    system "#{bin}/plaympeg", "--version"
  end
end
