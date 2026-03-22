class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.8.2/rizin-src-v0.8.2.tar.xz"
  sha256 "1630ca52bae86f2ff37eb220699fc82f951b5b18080edfa3f50dd36a526c2d95"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "b46c736276c060f36dccbb6bafc5216d7010b8ec4d5864b5f4ec8536d611bfde"
    sha256 arm64_sequoia: "72fb388c5879904773c4e4da645ede12114e1c0e678fd20019477256d6b58f1c"
    sha256 arm64_sonoma:  "9fe0bec7ad14cf2256eb8161792dc4e7c7652e7356d404726c19b2eea0c645d1"
    sha256 sonoma:        "4af3b7d816afea6cd2c8410faed4ba8b4239820b1927eb599f4633a7d3f6318c"
    sha256 arm64_linux:   "c7546ce2d1464e6f8650a589e503466e789aacf59c368ba076ea9d66021fd12e"
    sha256 x86_64_linux:  "07d86a1c8573f66cc6b7f0f76a7cc04dc98a1d46d4788986ad8a644458ee6be0"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
