class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.4/rizin-src-v0.7.4.tar.xz"
  sha256 "f7118910e5dc843c38baa3e00b30ec019a1cdd5c132ba2bc16cf0c7497631201"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sequoia: "c9854ebc1a48bd0c3ad95e6280bd64286eec7c9da4a786816d56966b49dddbc4"
    sha256 arm64_sonoma:  "3c1915fd5bcd0e5c405c89345ef5b11bc1ff0439a26e014d197830b94d409307"
    sha256 arm64_ventura: "36e6d99be00280b12b61e2a26867bced9c8d9b804207d660955f9935f9899191"
    sha256 sonoma:        "f1f5b38a621a1a3a9da4027d564bf4fd7399a1a42b575d10c1f51b200fd9d1b9"
    sha256 ventura:       "ecada780645e39bd0f85be6129b89e2e85b80d81fb1bad621bc476bb88829385"
    sha256 x86_64_linux:  "a8cbce5bb6b3ae52b611b07247208d023ffcdde27ab6abb9cd432e084e064211"
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
