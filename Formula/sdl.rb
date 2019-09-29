class Sdl < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick and graphics"
  homepage "https://www.libsdl.org/"
  url "https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
  sha256 "d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00"
  revision 1

  bottle do
    cellar :any
    sha256 "7711f995186b4aa6dff3f9821be99bbb1c455b32d353adf6b2fd5ec6404a52a3" => :catalina
    sha256 "28bfde74acbd1e68c0c2600d0bef4ebe7baf089f62f957779deb2c5dc0df2dd9" => :mojave
    sha256 "115af7ed86433a36baf4ca221bf19a7a61059fb6c2e55ae3d499fd7cdc2854bc" => :high_sierra
    sha256 "8e69b2fb9f67413080c1fe5bd445f02017c863228ca231a62165738953207709" => :sierra
  end

  head do
    url "https://hg.libsdl.org/SDL", :branch => "SDL-1.2", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
