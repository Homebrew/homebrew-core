class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.4.1/rizin-src-v0.4.1.tar.xz"
  sha256 "669d956b997820a36e423cf35d482aa99849254b9658cef6844459912dfdbfb8"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "8c74fabf96018a03aa29a1362729ca6ed5dbbe787a27b8d7c4d43fb7f1be3c48"
    sha256 arm64_monterey: "c04c60e8834648bea585014cd5e00a4900a1f41e95ea67adc92e2bf094136c09"
    sha256 arm64_big_sur:  "c1b7a23fca85bf610789e9f8cf3e50bee631c9e711f4ba1612291a0f35979092"
    sha256 ventura:        "3c86cb6d5529c3baae5367f4d4d626e9af0792262a2b030ff41057c1110bb8d8"
    sha256 monterey:       "6127e3bfbf3607835e4894aca4ffcd4c08f56ce2c5e2cbb35511981da3bc760c"
    sha256 big_sur:        "e1dbdf060e19defa2c3a2e82434387899d37d2ea7276d9dcba538d9a1053c377"
    sha256 catalina:       "35b645f1e1cb630e38d38b6688c0bb3f644d36c792038f21c6f87eceab83e2a1"
    sha256 x86_64_linux:   "266f41d8b9df51e7f172707d7b79db9c182529258da301e9d8e66be91d9ff2e9"
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
