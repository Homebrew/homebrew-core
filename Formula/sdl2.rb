class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.12.tar.gz"
  sha256 "349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863"

  bottle do
    cellar :any
    sha256 "dc47470e4dc13c7a0cf48330da2d4938695a5b60bf9d6ef31218f32a803ab48c" => :catalina
    sha256 "ede7f2495e32fd7f1a1bee57db35542066993f7ad4d24bb4c2078a68b0856dfb" => :mojave
    sha256 "e8e7c8484eaa791d312f9d77f626faad344f90db74bb93423ed2fc234c5f52a6" => :high_sierra
    sha256 "67961a420c2a8632822f60f61710b95b1173b8b1c2ae05b5f92e4c9892cdc5b7" => :sierra
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --without-x]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
