class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.4.0/rizin-src-v0.4.0.tar.xz"
  sha256 "09eba8684fe813cf42a716b59a86d3d65afce013d7e8b275e145e849d3366b5a"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "ea7541a46a6e4b0fdbd60ea2f8653affdb3398acc4a14dcf363b897dd09f3d13"
    sha256 arm64_big_sur:  "0fd28a886e5274608e8c4b9df330ebc2e6ab4dcb5170e1f2ee1b4770bfd52f40"
    sha256 monterey:       "51860beb6fcebc2715afef2347191ae85f8024a467afdce18e2def8460872ffa"
    sha256 big_sur:        "ab5125b4cd17fc30e81a24430cc417b044b6a6c674b1e6978d3a08b88fb66edd"
    sha256 catalina:       "c5e76ca21376cf458b03ac71ae82b2b5776accadfef94c457a12627f1d9221e6"
    sha256 x86_64_linux:   "c4ac63f6cb764721c72490a884700a03a28f443db91ef4e3b2cc319483bfc6d4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libuv"
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
        "-Duse_sys_libuv=enabled",
        "-Duse_sys_openssl=enabled",
        "-Duse_sys_capstone=enabled",
        "-Duse_sys_xxhash=enabled",
        "-Duse_sys_magic=enabled",
        "-Drizin_plugins=#{HOMEBREW_PREFIX}/lib/rizin/plugins",
        "-Drizin_extras=#{HOMEBREW_PREFIX}/lib/rizin/extras",
        "-Drizin_bindings=#{HOMEBREW_PREFIX}/lib/rizin/bindings",
        "-Denable_tests=false",
        "-Denable_rz_test=false",
      ]

      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/rizin/plugins").mkpath
    (HOMEBREW_PREFIX/"lib/rizin/extras").mkpath
    (HOMEBREW_PREFIX/"lib/rizin/bindings").mkpath
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
