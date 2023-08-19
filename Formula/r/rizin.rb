class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.0/rizin-src-v0.6.0.tar.xz"
  sha256 "6a924906efdf547ac50462767f5add53902436e7a4862d2c0e24ca91b7761508"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "851c6ea0a78df7ef9099c5f25ee607be12be0edcea789ed368fe25599bae8c8d"
    sha256 arm64_monterey: "cd638a3a23f28fcd7380dbba4ddef251f04c7bacd5a6bb7a31fe035a05829d3e"
    sha256 arm64_big_sur:  "e20a047829d5ac1ed6a0aa549a70b87375057d7e6249a82606e86529f1d4dffa"
    sha256 ventura:        "f94f9267c6eadffbf82f70ef383db5d779083770f056c05f81dc0865da9405f3"
    sha256 monterey:       "19c9c269c670341b1cf9de0fd1f8b14be0a59ba87f163b27c8754c1985d7d2ca"
    sha256 big_sur:        "c01368faee40cd7183e98e792dd4767eb8d0c35009699e44084c787dc5ef9372"
    sha256 x86_64_linux:   "f97f900b84442c0b2e078a9ee0864670bcaeddfdc2529b6b5c9cc9a41d141688"
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
        "-Dextra_prefix=#{HOMEBREW_PREFIX}",
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
