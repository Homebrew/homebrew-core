class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.4.0/rizin-src-v0.4.0.tar.xz"
  sha256 "09eba8684fe813cf42a716b59a86d3d65afce013d7e8b275e145e849d3366b5a"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "3f487bf1891f3ae635b5e38773a8b0e149c384e6d676d63192c10f33e2dbc8e0"
    sha256 arm64_big_sur:  "a3d46b04566bf06e4a654d051725bc9f4fbe570b19eeeea23fd0bd6c6126311c"
    sha256 monterey:       "60c9cc6547b53c0f365e4f071d7950ff8f89be136054ab73734d3630ea4e4442"
    sha256 big_sur:        "f4e26de5f4f0d2a2a41b2d361c246f7aa2f3d07a7577561eaf39cece5c8db431"
    sha256 catalina:       "4dbe1219f669b093a0477f1ab544aa8cac937a472b0919142973f6b93e677f08"
    sha256 x86_64_linux:   "cacc8f922ebe8deb752054183c7435815d16f63723e9d24c97f0ff43fee9332c"
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
