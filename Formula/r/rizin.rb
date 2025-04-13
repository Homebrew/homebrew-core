class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.4/rizin-src-v0.7.4.tar.xz"
  sha256 "f7118910e5dc843c38baa3e00b30ec019a1cdd5c132ba2bc16cf0c7497631201"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sequoia: "72e7554b32c691c794bc33fec7e9a22568a44ace68bd0ada691f8536be27f865"
    sha256 arm64_sonoma:  "c2b60efec9e77b47d5295b947c0d67a25e7377a11a0496b41b8119d653df4857"
    sha256 arm64_ventura: "d0b7c57ace5a8845a7a9cb1cea2bd722f96772376bba6a2ed9932ac6234a269b"
    sha256 sonoma:        "9b0e91753ad69d002f079108bad3fc7182041d5cc540c88ee79595e2809b724a"
    sha256 ventura:       "022364accc372f60791c70e778d7a93f4ce065dc44a17767f0789b98a5680e3b"
    sha256 arm64_linux:   "c93c59a13793f75540fd4de561e9c1240a41ff11f7128b4aaf6169bc391adbe9"
    sha256 x86_64_linux:  "4f10fb6b1caced9fc229536a711097b10c143f9ff3b946cb82681d419bcdc5c5"
  end

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
