class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.3/rizin-src-v0.7.3.tar.xz"
  sha256 "e0ed25ada6be42098d38da9ccef4befbd549e477e80f8dffa5ca1b8ff9fbda74"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "74364fdd3b8a5ac67ff32db93fe428f02a7b3b9da438781df82b49841a19f8d1"
    sha256 arm64_sonoma:  "12675702b9239c67da1a3310062b93348b483848e135b6dd9c2c9dab880f733a"
    sha256 arm64_ventura: "bb6092d27f061ff2a7893ec87006796db07cec3ecd0975520f51c0483772f98c"
    sha256 sonoma:        "08c7e0da37059924db22e66ab9b8000dba160afaea2e5acc93034442b19afcc3"
    sha256 ventura:       "12056a2ea39056dc54842eb5febf07b3fe54be67d139849fa827dfc28241592b"
    sha256 x86_64_linux:  "755afa76deb4ba4fdd8c4f5e1e5aba43c951c5d30931c6570280fbd9b9023f5e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
      -Duse_sys_tree_sitter=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
      --wrap-mode=nodownload
    ]

    fallback = %w[rzgdb rzwinkd rzar rzqnx tree-sitter-c rzspp rizin-shell-parser rzheap]
    fallback << "ptrace-wrap" unless OS.mac?
    args << "--force-fallback-for=#{fallback.join(",")}"

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
