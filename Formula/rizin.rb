class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.0/rizin-src-v0.6.0.tar.xz"
  sha256 "6a924906efdf547ac50462767f5add53902436e7a4862d2c0e24ca91b7761508"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "dab22a50a7ceb810cbbe56539e3c40db2a1a4d2dd0004668e181d87c0dbed212"
    sha256 arm64_monterey: "b013b48ef8c24dad5e6da7dbb15e679071ecd617e53c8ebf4ab87a4c6d741b84"
    sha256 arm64_big_sur:  "ffd62c3ae5dafb88563d19950845e78f565c528f20d85c9f2988c20cfbe96fe2"
    sha256 ventura:        "e1de78b77a4cfc8202a8528dd688fd87a2bba4524512c7e901a70ac341e3313b"
    sha256 monterey:       "e74641cd40714ad377109eee3184c5124fd97e7751fad5a169f5c75c4228c939"
    sha256 big_sur:        "2762e8f6f570013c483d135a1f1addb178205993196dd55c3be027514e2e4141"
    sha256 x86_64_linux:   "e102a7b0156390ea0be2dc1bceb7c0ac22c2a759fc10148d5e8ad946351496e1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "tree-sitter"
  depends_on "xxhash"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      args = [
        "-Dpackager=#{tap.user}",
        "-Dpackager_version=#{pkg_version}",
        "-Duse_sys_libzip=enabled",
        "-Duse_sys_zlib=enabled",
        "-Duse_sys_lz4=enabled",
        "-Duse_sys_tree_sitter=enabled",
        "-Duse_sys_openssl=enabled",
        "-Duse_sys_libzip_openssl=true",
        "-Duse_sys_capstone=enabled",
        "-Duse_sys_xxhash=enabled",
        "-Duse_sys_magic=enabled",
        "-Drizin_plugins=#{HOMEBREW_PREFIX}/lib/rizin/plugins",
        "-Denable_tests=false",
        "-Denable_rz_test=false",
        "--wrap-mode=nodownload",
      ]

      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
