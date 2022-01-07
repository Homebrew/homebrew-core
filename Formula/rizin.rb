class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.3.3/rizin-src-v0.3.3.tar.xz"
  sha256 "86f091db3a65817c389c2f61f88c8facf25c8612a6899146d4fdbd76497c78df"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "ce2aa74010afedd9b820fd4b6dc13730e62410f523ea3c915658721c63acb88d"
    sha256 arm64_big_sur:  "0fd5609681b01999a3e05f92daa4cc311a4c5eed2fe8c5fc234968d43e26b77e"
    sha256 monterey:       "db54f9a88501294938b7a93645b47fd3b156648cc1ab0571e0a257a89bc89ea9"
    sha256 big_sur:        "87b6ae73978cb9c5ce14ba474b233eb8a1d84cafa56f13f53223edcecc8bb84d"
    sha256 catalina:       "493d33e099d15bd29a5ad88b07043abda99da10fa30e24f164116913a6bf9fe3"
    sha256 x86_64_linux:   "cc6012395617d5c425a39d4915b2df2550dd32b5de6fdc4b3d08a6d08fdb786d"
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
