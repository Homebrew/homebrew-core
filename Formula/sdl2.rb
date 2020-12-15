class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  license "Zlib"
  revision 1

  stable do
    url "https://libsdl.org/release/SDL2-2.0.12.tar.gz"
    sha256 "349268f695c02efbc9b9148a70b85e58cefbbf704abd3e91be654db7f1e2c863"

    # Fix library extension in CMake config file.
    # https://bugzilla.libsdl.org/show_bug.cgi?id=5039
    patch do
      url "https://bugzilla.libsdl.org/attachment.cgi?id=4263"
      sha256 "07ea066e805f82d85e6472e767ba75d265cb262053901ac9a9e22c5f8ff187a5"
    end

    # Fix configure script detects Apple Silicon Macs as iPhones.
    # https://bugzilla.libsdl.org/show_bug.cgi?id=5232
    patch do
      url "https://hg.libsdl.org/SDL/raw-rev/af22dd6c0787"
      sha256 "df68efb43e451789c1bf2873dabc9a70c66264f8b7ad360a71ea4c643c6acc37"
    end

    # Fix make install command. Patch should be removed when updating to next version.
    # https://bugzilla.libsdl.org/show_bug.cgi?id=5399
    patch do
      url "https://hg.libsdl.org/SDL/raw-rev/cf83f816421c"
      sha256 "6a5979e05872d2d86df2cab5db30489ba2e7c743596c8c3ed0c4a2f2969f3970"
    end
  end

  livecheck do
    url "https://www.libsdl.org/download-2.0.php"
    regex(/SDL2[._-]v?(\d+(?:\.\d+)*)/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "bdf2c30a7267e33a214a0170b6639a31f6a86b5ae524ebfa9dcb06c54d2c1514" => :big_sur
    sha256 "d02d45d59eabad3ed6ffdd780e44f798f35748a1080ce48ded17934bd0db2e05" => :catalina
    sha256 "6ff1b92dc1515a631549343ea7f52ddc108e5a08cd5f462f2ba0a31a04fd0d13" => :mojave
  end

  head do
    url "https://hg.libsdl.org/SDL", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    # we have to do this because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --without-x --enable-hidapi]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end
