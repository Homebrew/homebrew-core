class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.9.1/rizin-src-v0.9.1.tar.xz"
  sha256 "7ac1cd7daca7afdda742e15478b1f747fc1f813e496fee71839d1e109e543dca"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_golden_gate: "c1e566ba0220f27bad79cd83a74c67ddd37778e86b96a4d8fa8617e710dd6e5a"
    sha256 arm64_tahoe:       "300c7829238fcad0718decc9ca8a37d6fa48737bbcfe2fc604cfe79fe52da177"
    sha256 arm64_sequoia:     "a7fcb87c28c47ddf4c295f4063b6a2a5450076f4cfafe52ec3bd6451de1b291a"
    sha256 arm64_sonoma:      "ba43503e7975796d6cfe415b9df863aa21bb0c826098b0519b0326f0dc50178f"
    sha256 arm64_linux:       "de6387d5e1843b2ea960778bb289f49c64dd000d5d8302721fb032ccb52ed046"
    sha256 x86_64_linux:      "7ccffe9f458255aa30939d0aab2ca88dd10e28b1fa64cad7a24e31e064fdb2c2"
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
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"
  depends_on "zydis"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      --wrap-mode=nodownload
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
