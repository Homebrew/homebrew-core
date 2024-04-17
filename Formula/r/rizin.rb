class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.3/rizin-src-v0.7.3.tar.xz"
  sha256 "e0ed25ada6be42098d38da9ccef4befbd549e477e80f8dffa5ca1b8ff9fbda74"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sonoma:   "b6d421f03bb42ad27a0538a7e24e2ff658332864d3f0bcbdc9da49e4ef43b8e3"
    sha256 arm64_ventura:  "d45f434a310b2f37e931664b2f318b8c60e5d2dcad34d7bc908df53ddfe8a856"
    sha256 arm64_monterey: "5fa93764282c486581b950a2cafdcf7f5707d4dd8de72cf88ce42395db818e26"
    sha256 sonoma:         "94a12a06e37d4d51bffb71fdd62e26733d12742391019d462468c8d80e81d079"
    sha256 ventura:        "0ee89920c5c0cffafd62ad5659e448078975fd43c006caafebfaf3f287107c9b"
    sha256 monterey:       "7274efb7cffd09774ee1fdd79828e7084243cb0b8b6f25628bdc0c1a0bece648"
    sha256 x86_64_linux:   "6ea8d1b38387b296225cc5e2fab8e46853477c4388902faa8f68423d42fe1760"
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
