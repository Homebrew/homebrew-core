class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.9.1/rizin-src-v0.9.1.tar.xz"
  sha256 "7ac1cd7daca7afdda742e15478b1f747fc1f813e496fee71839d1e109e543dca"
  license "LGPL-3.0-only"
  revision 2
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_golden_gate: "0ac456ddf4091f012260a63fc9b14a408fc06bc9ea6b3833bd42f96b8ec7a395"
    sha256 arm64_tahoe:       "ce7a6a0d2970e512721ed5a8f5f541e62a6ee3dec0072b55e4300e5646c19fc0"
    sha256 arm64_sequoia:     "79a65682c26d17f9c9e347ec3ca681728d9467242e2127269e566e7e9303b2b6"
    sha256 arm64_linux:       "a9fa1e59b124a6229775a74a0b1c6cb1eb7302ef9949be01bda2a0c2af8ce18e"
    sha256 x86_64_linux:      "a769d7926bfd33df56538c5f7ab0d83799ee4725602aa5a38a484b17c336c185"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "blake3"
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"
  depends_on "zydis"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -Dpackager=#{tap.user}
      -Dpackager_version=#{pkg_version}
      -Duse_sys_blake3=enabled
      -Duse_sys_capstone=enabled
      -Duse_sys_libzip_openssl=true
      -Duse_sys_libzip=enabled
      -Duse_sys_libzstd=enabled
      -Duse_sys_lz4=enabled
      -Duse_sys_lzma=enabled
      -Duse_sys_magic=enabled
      -Duse_sys_openssl=enabled
      -Duse_sys_pcre2=enabled
      -Duse_sys_tree_sitter=enabled
      -Duse_sys_xxhash=enabled
      -Duse_sys_zlib=enabled
      -Duse_sys_zydis=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
    ]

    fallback = %w[blake2 rzgdb rzwinkd rzar rzqnx rzspp rizin-shell-parser rzheap]
    fallback << "ptrace-wrap" unless OS.mac?
    args << "--force-fallback-for=#{fallback.join(",")}"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    mkdir_p "{{HOMEBREW_PREFIX}}/lib/rizin/plugins"
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
