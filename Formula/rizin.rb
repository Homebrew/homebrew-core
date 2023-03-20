class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.5.1/rizin-src-v0.5.1.tar.xz"
  sha256 "f7a1338a909de465f56e4a59217669d595153be39ee2de5b86d8466475159859"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "af85de7434c87871d4ec012ebd1d88c4b18bb7d5a46b8de2efd717bfc17ede1a"
    sha256 arm64_monterey: "1c79e16d6d34e35fd98fbc4f4fd68d49400723e26c1ffbfb2766248de5fe36f9"
    sha256 arm64_big_sur:  "97972495ae0938c5879fa581c8937f412f7837925ed5d0c1b8bc285c5aad21d4"
    sha256 ventura:        "d65c985eb91505d8bf62be45efb9b94d7a3e28a5c0cc17d7e727cf2a2b03e1ad"
    sha256 monterey:       "9930684d08fe7850c72275b57a7d93f29d25e6fc48a8394bc541e6bd0c2e8340"
    sha256 big_sur:        "fbea8f829e4cd8c58371caafc956d3b46cb2cac18d0226711674ee29ac92ffe5"
    sha256 x86_64_linux:   "c83d1d539ddbe37fc0775987cd9748d604041b973209e373e20310fa638e293d"
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
