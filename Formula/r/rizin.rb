class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.8.2/rizin-src-v0.8.2.tar.xz"
  sha256 "1630ca52bae86f2ff37eb220699fc82f951b5b18080edfa3f50dd36a526c2d95"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "ca31e037dd1d34dcff7f37406c9af109ca12522d52922d28c0abce9b8b747db6"
    sha256 arm64_sequoia: "f7190fe7bca63a8c2ca2e8c4f72c14e7fc815de189b6af7c382a86a7af2f64de"
    sha256 arm64_sonoma:  "20f58e7fb1b38b90ba58bf8ab6762444dd67ec4c12e91be4986426570085df31"
    sha256 sonoma:        "697b5eddf496c84d87f05f500a4d46228e2f68be1832633b21f2da3a28073c12"
    sha256 arm64_linux:   "a7233e35d553f36274edee99addc90cf9790f6f1cefd8d6cf43154108b4e0006"
    sha256 x86_64_linux:  "8f0724ae3761b7a6cddf5392cc3c73fe141b37e14d7bab03147c94d0cf13145a"
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

  post_install_steps do
    mkdir_p "lib/rizin/plugins", base: :homebrew_prefix
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
