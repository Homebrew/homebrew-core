class Sdl < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick and graphics"
  homepage "https://www.libsdl.org/"
  license "LGPL-2.1-only"
  revision 3

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

    # Fix display issues on 10.14+, https://bugzilla.libsdl.org/show_bug.cgi?id=4788
    if MacOS.version >= :mojave
      patch do
        url "https://bugzilla-attachments.libsdl.org/attachment.cgi?id=4288"
        sha256 "5a89ddce5deaf72348792d33e12b5f66d0dab4f9747718bb5021d3067bdab283"
      end
    end

    # Fix audio initialization issues on Big Sur, upstream patch
    # http://hg.libsdl.org/SDL/rev/45055c672931
    if MacOS.version >= :big_sur
      patch do
        url "http://hg.libsdl.org/SDL/raw-rev/45055c672931"
        sha256 "4bc838bcfe8f671e016d22d9319cb39ca94052b86ad45b805d9b4d32564ef836"
      end
    end
  end

  head do
    url "https://hg.libsdl.org/SDL", branch: "SDL-1.2", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  livecheck do
    url "https://www.libsdl.org/release/"
    regex(/href=.*?SDL[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "d97aac056338f24b09ff065d8a80c6f5e9b6e16aed93003764054f6703093ecd" => :big_sur
    sha256 "c3fda7b3047ffff537ba6f2a5711fd03f50fa776546d7788f42a4df325944fcf" => :arm64_big_sur
    sha256 "060c0297dd0af2e289196aa196341ece04f3ab4a3458d173e74f2a3865046a8f" => :catalina
    sha256 "683450f850acbc501144207d237d28a9c3d0af86533065db7bf7b23ae2d1f6e5" => :mojave
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
