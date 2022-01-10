class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.3.4/rizin-src-v0.3.4.tar.xz"
  sha256 "eea49b396387c09d19705aab02a617cdb15682fca67f101ff2b27eef94a710e9"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "dcfcb37bd362f88d986bd5b20e32ae2106034a1d175074b406deae12b2c1b041"
    sha256 arm64_big_sur:  "fafbc6336deea70798b77c1e14c38c09554f2a62b1f5740e1942e53ab68573f3"
    sha256 monterey:       "cb4808cd20d3187de68a42897aa487c7907f145541e968cb0512279fa4fad273"
    sha256 big_sur:        "246ed9600457933e128c6f837e48fc00246433f8a01b0daae987d3cae3ef309e"
    sha256 catalina:       "faa337df01ac35ddbbc02578fc0af13afe7c0ca36bbf3abe036b2e43b4e6fcad"
    sha256 x86_64_linux:   "8adb6323a58e73d07806cf7bb7e1d5ea1cd39269c95e1a36fad58ef9964bbfda"
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
