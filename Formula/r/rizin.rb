class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.1/rizin-src-v0.6.1.tar.xz"
  sha256 "760647caf8a78a638a0e040bf7b89c3ed064fabdfeac4fe44ff15d62baac6c91"
  license "LGPL-3.0-only"
  revision 1
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "fa18e2e8e95c3fbf47637ab8aeee8c968d3f7309c360dceab1cdb425821f006c"
    sha256 arm64_monterey: "a2a6dad5f6d676d3bb270bf872b16dff8742ad6087c30685c02a64d19eef44c4"
    sha256 arm64_big_sur:  "f2719040f43665978fbd105786972d755c04b34f00f81ba1478d3b2ab861cdaf"
    sha256 ventura:        "56f79b6362437028ffda3e2c6b6bcbedce44af5ed727b38e4468b38c53d5d8ff"
    sha256 monterey:       "04f1cbb0d44ddd34834bb2af4aebabd17cac4bcc285854859224868674eb5bee"
    sha256 big_sur:        "a3682fc67aeb116fefc9e3029223178de6a3d943260bdc638742d97931a1c90b"
    sha256 x86_64_linux:   "2fcd6facfca8fa3f6c5f4d7276c6a62a7891873ae531fdce24fbbc549be0b2ed"
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
