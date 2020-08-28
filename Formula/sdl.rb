class Sdl < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick and graphics"
  homepage "https://www.libsdl.org/"
  revision 1

  stable do
    url "https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
    sha256 "d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00"
    # Fix for a bug preventing SDL from building at all on OSX 10.9 Mavericks
    # Related ticket: https://bugzilla.libsdl.org/show_bug.cgi?id=2085
    patch do
      url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1320"
      sha256 "ba0bf2dd8b3f7605db761be11ee97a686c8516a809821a4bc79be738473ddbf5"
    end

    # Fix compilation error on 10.6 introduced by the above patch
    patch do
      url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=1324"
      sha256 "ee7eccb51cefff15c6bf8313a7cc7a3f347dc8e9fdba7a3c3bd73f958070b3eb"
    end

    # Fix mouse cursor transparency on 10.13, https://bugzilla.libsdl.org/show_bug.cgi?id=4076
    if MacOS.version == :high_sierra
      patch do
        url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=3721"
        sha256 "954875a277d9246bcc444b4e067e75c29b7d3f3d2ace5318a6aab7d7a502f740"
      end
    end
  end

  livecheck do
    url "https://www.libsdl.org/release/"
    regex(/href=.*?SDL[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "98b91b216ee0a29425796e5ece1062b4d57535dd83c68d8ffd23dafd9ca102d3" => :catalina
    sha256 "b19b93f980a305d7e18b3f3d59b0679e4f91c11dd51334725cc9244a74a2e177" => :mojave
    sha256 "2580e605dc4d53ea5d321c8cf8451a16630199a01bdcb7c7e0b8f39bfd6ed068" => :high_sierra
  end

  head do
    url "https://hg.libsdl.org/SDL", branch: "SDL-1.2", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl.pc.in sdl-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix} --without-x]
    system "./configure", *args
    system "make", "install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"] if build.stable?
  end

  test do
    system bin/"sdl-config", "--version"
  end
end
