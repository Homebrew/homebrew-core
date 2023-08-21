class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.1/rizin-src-v0.6.1.tar.xz"
  sha256 "760647caf8a78a638a0e040bf7b89c3ed064fabdfeac4fe44ff15d62baac6c91"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "d09c0803260afd0be84d54486ad622a2cc7e6cf19a1602b8c2b5124b20160e0d"
    sha256 arm64_monterey: "84a525bbe108e0f8b2edde68e6579996b2fccb3f3747accfb6b6adae39864fb7"
    sha256 arm64_big_sur:  "13c7999c3d60a008a3420d7c5091bd6f1cbec5e20aed4b05e2e43ce4f41571d9"
    sha256 ventura:        "6881398daeb2cf5ebb5b98b1e6ed6d20815871f7e6d66f52a4db1bf72b7e086c"
    sha256 monterey:       "fc1c704ba466a5fee2f9c482638ea4ade4cc0a1f72a1f5c8f119a9a6a25d56c5"
    sha256 big_sur:        "6fe774d10ffe33393ea3887d929e1852b2f57e82591017de065b9366c0318556"
    sha256 x86_64_linux:   "0a87e19462967b7458130f897db7064454b9ee95b5baccee774e6097de739f99"
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
