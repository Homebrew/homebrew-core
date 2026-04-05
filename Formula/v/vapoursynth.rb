class Vapoursynth < Formula
  desc "Video processing framework with simplicity in mind"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/vapoursynth/archive/refs/tags/R74.tar.gz"
  sha256 "9ebf49720a48a6b5e4abdfd969f318545dde82d67f3e3c68a0799371333d96be"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/vapoursynth/vapoursynth.git", branch: "master"

  livecheck do
    url :stable
    regex(/^R(\d+(?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "badc56f5fb9d2c6c5963df0f619b08c74b098d1835126f8cd9c1b15fcce33aee"
    sha256 cellar: :any,                 arm64_sequoia: "3af090044e6962bdcc19c4e92dd724d1ec07cb6bc3e958721d2f63dcab766cf3"
    sha256 cellar: :any,                 arm64_sonoma:  "bdab1c52e43ec390ca27d76f07b1f43967b0f091c09da17e756e81bb879cd350"
    sha256 cellar: :any,                 sonoma:        "bd2188a75e9cd09589e746facd492c5ff8342fbffc71e7f6aebda2b74bb523a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5e6a5ecdb6203b2979ab67a27bcc400fe4baffc42459346e5d83c2f187696a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a020d5253bc39fbe0f077128478632d24ab5d19e375e94a1d8ed08583558c0df"
  end

  depends_on "cython" => :build
  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14"
  depends_on "zimg"

  # std::to_chars requires at least MACOSX_DEPLOYMENT_TARGET=13.3
  # so it is possible to avoid LLVM dependency on Ventura but the
  # bottle would have issues if system was on macOS 13.2 or older.
  on_ventura :or_older do
    depends_on "llvm"
    fails_with :clang
  end

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["llvm"].opt_lib}/c++" if OS.mac? && MacOS.version <= :ventura

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    sleep 1000
  end

  def caveats
    <<~EOS
      This formula does not contain optional filters that require extra dependencies.
      To use vapoursynth.core.sub, execute:
        brew install vapoursynth-sub
      To use vapoursynth.core.ocr, execute:
        brew install vapoursynth-ocr
      To use vapoursynth.core.imwri, execute:
        brew install vapoursynth-imwri
      To use vapoursynth.core.ffms2, execute the following:
        brew install ffms2
        ln -s "../libffms2.dylib" "#{HOMEBREW_PREFIX}/lib/vapoursynth/#{shared_library("libffms2")}"
      For more information regarding plugins, please visit:
        http://www.vapoursynth.com/doc/plugins.html
    EOS
  end

  test do
    system Formula["python@3.14"].opt_bin/"python3.14", "-c", "import vapoursynth"
    system bin/"vspipe", "--version"
  end
end
