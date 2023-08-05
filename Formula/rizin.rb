class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.6.0/rizin-src-v0.6.0.tar.xz"
  sha256 "6a924906efdf547ac50462767f5add53902436e7a4862d2c0e24ca91b7761508"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "8c1388c781a14fdd4e2dc4eab5b9cd2f48e2fd50187b6c3786b971d3134d85c1"
    sha256 arm64_monterey: "850e27f95744be857b53d56b6c5fe182680da040a5ed06ed0f1071aa05970068"
    sha256 arm64_big_sur:  "76caa2de6c1cf52b93cdf826a1d21a939dd9682b78ac09453f2963b1ebec839c"
    sha256 ventura:        "9b9cd512ec4bc3fd42bf584203f5dce63bc6b401510ee19f320b344ced688bd7"
    sha256 monterey:       "d58af64e517bb359d0fd95d55ed06f6f05184ac7d37dda651c066640a4ea6ed9"
    sha256 big_sur:        "b12d0a74a6e028a476efdaabb3cbacc4338532064a3cbd5654ad909d63c9ed4e"
    sha256 x86_64_linux:   "980ae4aa26387f499242f7375b15f753fcb0ed843d8eeab8081ad20af33dad86"
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
