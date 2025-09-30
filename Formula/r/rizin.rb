class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.8.1/rizin-src-v0.8.1.tar.xz"
  sha256 "ef2b1e6525d7dc36ac43525b956749c1cca07bf17c1fed8b66402d82010a4ec2"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_tahoe:   "f25462fa15671a16f9981b68ec46e4d5acd36456fe11074e55ab5cb5442a58af"
    sha256 arm64_sequoia: "7c1365dc16e0421bca82d1b045973bbada8191297992744fa8311b9b271645fa"
    sha256 arm64_sonoma:  "328c1528f26638dd2ea942c0c2bbc4dfa7745c56cde1252b9638712003d317c0"
    sha256 arm64_ventura: "085d109b54887985cd8b0a6fa0871992f7019b87ba95f81d1d9fbf11d2448f0c"
    sha256 sonoma:        "9a9270d14cd3a2aa28b06f20b7197277e3964e6c168df012ca803c1c913b8bf8"
    sha256 ventura:       "f274b57f7f40220103f294b245487cc149030390ff1e114082de554b08b10d5b"
    sha256 arm64_linux:   "450223987c11d8a126f9167278b987c77d113c94092857e8568b71d50e4aa268"
    sha256 x86_64_linux:  "05ec7e5950237bb3d0640c5dae2061b878e30da76306f5272bae0466c1bb2f21"
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
