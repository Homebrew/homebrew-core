class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.5.1/rizin-src-v0.5.1.tar.xz"
  sha256 "f7a1338a909de465f56e4a59217669d595153be39ee2de5b86d8466475159859"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "d57557c11cd249618370438570556b04a457bc9d83c018d433a53bdb92f3c9ee"
    sha256 arm64_monterey: "217c39d3197b31d88a573d259180c0880814c6bc4d32c709a890f5d5078324ca"
    sha256 arm64_big_sur:  "819444b1f40e3f5ce5245f344e269cff3b9dbf37664028882771c75654014fe0"
    sha256 ventura:        "1db2cc0721fbd4953e66d2a96a152e94ccf972e22e8116f540d7987e3e7edcbf"
    sha256 monterey:       "32dffc5909c355ffdc2a1cf29844edc980c3c64187b6b83b44cada9d2d70f71f"
    sha256 big_sur:        "1f379a0263d703c92be1d285e28fa84475ca421d53f6f8040c58a43350ac104d"
    sha256 x86_64_linux:   "0949c2db7a151de8cd8e5972922accad50c862bff40896c66bc73abe49a8038e"
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
