class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.5.2/rizin-src-v0.5.2.tar.xz"
  sha256 "71ab80fc3c8ac9c80a10000d838128af28a05d31a0ee183900c2c5c6e350eca3"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "cc0998ff47f612e9ead4ce953d4e93922891d878a8defef0faabef734682be3f"
    sha256 arm64_monterey: "718b7a618cd6513eab7bdbb30a865c9ffab3dba6e7686100a612fd57bcd2d403"
    sha256 arm64_big_sur:  "674c27bfb0e34dc25b2b1f2354d2d5c202388e6b30cd62ba713b6c7df81f0481"
    sha256 ventura:        "04d3d8d175b8962a287e73413fb313cad8619f857ff000146164eff87040f73d"
    sha256 monterey:       "19036e7942741e23ea6ecadaced732e9ee2ae2d240af68a2e82bcd1559fb948f"
    sha256 big_sur:        "6a58abb9f16c2a235f023bf4b129db57a78ef8e630377f2ba7edfb8e3b893f70"
    sha256 x86_64_linux:   "b8ceb72f3cf2bc52d6ce8fff421f6e893f2077f8e117841e6444a942112e633c"
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
