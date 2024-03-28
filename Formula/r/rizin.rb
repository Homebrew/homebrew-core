class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.2/rizin-src-v0.7.2.tar.xz"
  sha256 "fcff3fb45ae2b75e3f604bc7a08076e322e6e14def79098186378065ccb3582a"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sonoma:   "60049d407433aef6033edbef49debf112fa6ae983a2fa36ddc87e14dbe0cba48"
    sha256 arm64_ventura:  "edf5c3eb1e8be2cdd25c333badb634972ee82890dbe5b59cafe6d785e5eaff76"
    sha256 arm64_monterey: "f3f96eacdb829263bba7c7c6a590678dc69fa8b925b2882f8bcad9f2a3b1e05f"
    sha256 sonoma:         "bee6324e824f18c82f831c40fc86d25221923f2e9037a37b16cb04b0afa98803"
    sha256 ventura:        "b741aa7f6da709418d0a72a57a93793f144328253aa0c4a6ad165bf70b167a0a"
    sha256 monterey:       "3a32153a1739f151586c021d1dbe8d99bd24a55ccda31a382b9f8c8d7fc1f72b"
    sha256 x86_64_linux:   "3547d7514ff885c8b9d157f7d7c19a09665ad9e7c817121f90351158227fbd6e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    args = %W[
      -Dpackager=#{tap.user}
      -Dpackager_version=#{pkg_version}
      -Duse_sys_capstone=enabled
      -Duse_sys_libzip_openssl=true
      -Duse_sys_libzip=enabled
      -Duse_sys_libzstd=enabled
      -Duse_sys_lz4=enabled
      -Duse_sys_lzma=enabled
      -Duse_sys_magic=enabled
      -Duse_sys_openssl=enabled
      -Duse_sys_pcre2=enabled
      -Duse_sys_xxhash=enabled
      -Duse_sys_zlib=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
      --wrap-mode=nodownload
    ]

    args << if OS.mac?
      "--force-fallback-for=rzgdb,rzwinkd,rzar,rzqnx,tree-sitter-c,rzspp,rizin-shell-parser,rzheap"
    else
      "--force-fallback-for=rzgdb,rzwinkd,rzar,rzqnx,tree-sitter-c,rzspp,rizin-shell-parser,rzheap,ptrace-wrap"
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/rizin/plugins").mkpath
  end

  def caveats
    <<~EOS
      Plugins, extras and bindings will installed at:
        #{HOMEBREW_PREFIX}/lib/rizin
    EOS
  end

  test do
    assert_match "rizin #{version}", shell_output("#{bin}/rizin -v")
    assert_match "2a00a0e3", shell_output("#{bin}/rz-asm -a arm -b 32 'mov r0, 42'")
    assert_match "push rax", shell_output("#{bin}/rz-asm -a x86 -b 64 -d 0x50")
  end
end
