class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.2/rizin-src-v0.6.2.tar.xz"
  sha256 "e29a00a3e22004bdd10146d286b1cce0e06196d41aae4729aafc9d78321ff86b"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "d25e105b66cad21f89e9404990faaa709ec2437a11f6402ca87a6f049608607b"
    sha256 arm64_monterey: "35db62d58c5ee63450d0459ac73c7804c943d3e13ff08addaa9360bfa768b132"
    sha256 arm64_big_sur:  "f7139d17f16671225d7e604c910addef06cf7122f501a8518e02842a24fae52e"
    sha256 ventura:        "a521ec17ed67e879b4c2f5595dae3171a8485d92bccb8ace7565ebbdc954b5d6"
    sha256 monterey:       "a4ba60ec71dbbf5234d7e6056b2f2c2d2c511fcab4d321121320a353b9fd36d8"
    sha256 big_sur:        "e2b698934765e132f2107b391951f233c80f322b23fca77c653d84c8b23da6d9"
    sha256 x86_64_linux:   "13e5eb46d3609a27a4c709f42b9675ffd97cbefa848ed40516b3484e6b1de3fb"
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
