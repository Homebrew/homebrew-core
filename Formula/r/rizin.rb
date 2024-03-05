class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.2/rizin-src-v0.7.2.tar.xz"
  sha256 "fcff3fb45ae2b75e3f604bc7a08076e322e6e14def79098186378065ccb3582a"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sonoma:   "6d15d2aa32ecb84f9b0468a8ddd6a6f2f5fd71c348c5395b172371240ee8327f"
    sha256 arm64_ventura:  "e36d83d89a617f2e6151e47e757b48c5ae6a01d4c016eb1e728080376bb7779f"
    sha256 arm64_monterey: "82a23d49ac1c0fa6c91393d2e8cb99c4e86ce3817515311226b4b040dec5e67d"
    sha256 sonoma:         "125ea004df8a7df2359131ea5cfc33664d12aff8a66db55071a26c9097d37cb6"
    sha256 ventura:        "d42413910b2cb121adadfe55b806b0054ef6f5b9ad014e42a3f7be57a5a94334"
    sha256 monterey:       "cac2d262246420e36101061d368836216b18c2317afa7d1bb5e2a2d985e56d6a"
    sha256 x86_64_linux:   "e16784411cfaadc8aaadb6eedff72f47b576261becddd6c7df66e895436f05c9"
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
