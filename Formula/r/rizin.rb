class Rizin < Formula
  desc "UNIX-like reverse engineering framework and command-line toolset"
  homepage "https://rizin.re"
  url "https://github.com/rizinorg/rizin/releases/download/v0.9.1/rizin-src-v0.9.1.tar.xz"
  sha256 "7ac1cd7daca7afdda742e15478b1f747fc1f813e496fee71839d1e109e543dca"
  license "LGPL-3.0-only"
  head "https://github.com/rizinorg/rizin.git", branch: "dev"

  bottle do
    sha256 arm64_tahoe:   "cd8542861b5f961739e287d139df33ea1653fb545e972bf2f1892750041420c1"
    sha256 arm64_sequoia: "33d3a39989176e106488a91408f5c33855755dcf3b57ed2e563fed251183442b"
    sha256 arm64_sonoma:  "6e9b10c6ead173e20a3910eecfa2dd15acff1f63c8762899dff8f11f370e6d92"
    sha256 sonoma:        "4603e020ea1d44ddf279d09cb90751f2ce32241c95a737fa12626cf205c79d8d"
    sha256 arm64_linux:   "0da359bd50674636efdebb5032c991297409d074ffd8886d3aa60008836ebcdd"
    sha256 x86_64_linux:  "319ef2437f853598e9c6fbe6cd7bab7b60c8eb8a647049159e12160ed8feb8ec"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "blake3"
  depends_on "capstone"
  depends_on "libmagic"
  depends_on "libzip"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "tree-sitter"
  depends_on "xxhash"
  depends_on "xz" # for lzma
  depends_on "zstd"
  depends_on "zydis"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      -Dpackager=#{tap.user}
      -Dpackager_version=#{pkg_version}
      -Duse_sys_blake3=enabled
      -Duse_sys_capstone=enabled
      -Duse_sys_libzip_openssl=true
      -Duse_sys_libzip=enabled
      -Duse_sys_libzstd=enabled
      -Duse_sys_lz4=enabled
      -Duse_sys_lzma=enabled
      -Duse_sys_magic=enabled
      -Duse_sys_openssl=enabled
      -Duse_sys_pcre2=enabled
      -Duse_sys_tree_sitter=enabled
      -Duse_sys_xxhash=enabled
      -Duse_sys_zlib=enabled
      -Duse_sys_zydis=enabled
      -Dextra_prefix=#{HOMEBREW_PREFIX}
      -Denable_tests=false
      -Denable_rz_test=false
      --wrap-mode=nodownload
    ]

    fallback = %w[blake2 rzgdb rzwinkd rzar rzqnx rzspp rizin-shell-parser rzheap]
    fallback << "ptrace-wrap" unless OS.mac?
    args << "--force-fallback-for=#{fallback.join(",")}"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    mkdir_p "lib/rizin/plugins", base: :homebrew_prefix
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
