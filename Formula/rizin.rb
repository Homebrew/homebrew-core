class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.3.2/rizin-src-v0.3.2.tar.xz"
  sha256 "4fae609b5b5f443edd6522fca9928c4c06d0eb92f1fde72274573d4f56fb7228"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "2015c89cade24a58dea5145d9a109d8f3a1c3a8845ec0c02b5f818ba01c159c0"
    sha256 arm64_big_sur:  "b5166f24a8eb41e8f38e08070e24db30a36181aa7a09f5861672a3877ae852e3"
    sha256 monterey:       "e8d44363dc8e59f035f37e15e199a18d438eb2aef34bf3be334df786362b9c6f"
    sha256 big_sur:        "d3ff33c7b0067ce161fb235aae8b75420a8528699ab7ef9d036af7913af4decc"
    sha256 catalina:       "d890f8050d783a4a87499a72899b052e49f70e35d4e6ca7d721bfffdd3ef544c"
    sha256 x86_64_linux:   "4628797504cb11b0963bfac675b09ab7ad9afab39ea1bb52891bab9909099f29"
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
    # Workarounds for finding Homebrew dependences. Reported at:
    # https://github.com/rizinorg/rizin/issues/2013

    # Meson looks for `xxhash.pc` but we only have `libxxhash.pc`.
    (buildpath/"pkgconfig").install_symlink Formula["xxhash"].opt_lib/"pkgconfig/libxxhash.pc" => "xxhash.pc"
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"pkgconfig"
    # Meson's `find_library` isn't able to find `libmagic` without help.
    inreplace "meson.build", "cc.find_library('magic',", "\\0 dirs: '#{Formula["libmagic"].opt_lib}',"

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
