class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.7.0/rizin-src-v0.7.0.tar.xz"
  sha256 "fc6734320d88b9e2537296aa0364a3c3b955fecc8d64dda26f1f3ede7c8d6c31"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_sonoma:   "68dc52a271cc3e72781d63132f7fa7a9225d708b9ce0bb2c4f8c9545aecab368"
    sha256 arm64_ventura:  "50218f7c14aba77d9811a6b9768d4305cab7a7af672fa073654d56a37d818036"
    sha256 arm64_monterey: "b2276258bc3f7c815a360bcabdcbbcdc32fc2db55c0cc5cbed7a18fb51fa9edd"
    sha256 sonoma:         "14f9fb9f32b8218805b6305615cd34a59c5ebdf054b7fb5f11f265035ab6ec77"
    sha256 ventura:        "221106f01d703b344fbb00c93aa4008c404adddafb7b6a8b4ff771d45f5bf2e1"
    sha256 monterey:       "8f6ddcb0778d914cbf80f21dd3528ba8cde65331fe4670089543a6715715e7fa"
    sha256 x86_64_linux:   "3e1065a24509b5595a4ac936add5e07dab0fdfbfe841fc8211719703307eff13"
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
