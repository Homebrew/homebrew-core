class X8664ElfGrub < Formula
  desc "GNU GRUB bootloader for x86_64-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "53b8b89694c2d829f0b1a2d2f66d2337c989701666214a98bda3669e835ad9bc"
    sha256 arm64_sequoia: "5c7bf91186736387bce0a339c643572cbd603ff797360e3077b3d56568d9ede6"
    sha256 arm64_sonoma:  "ead30cf7afe4384bb52c9d6c1dc5f71d166de453043398a54728768d5e6845de"
    sha256 sonoma:        "550a7d1ac501183b9c04490744605f04c0320327832dfee05d0be280316db621"
    sha256 arm64_linux:   "ffb7c4eb420c42f558fe96e3692cbf5b2b3b3e1f1a2b6e66a5a5a03f5d7e2e20"
    sha256 x86_64_linux:  "02531df2a6711bb5519575d72c4c83f76f4d71f79caeb5172b3c102d601bc522"
  end

  depends_on "gawk" => :build
  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "x86_64-elf-binutils" => :build
  depends_on "x86_64-elf-gcc" => [:build, :test]
  depends_on "freetype"
  depends_on "xz"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz", using: :nounzip
    mirror "https://mirrors.ocf.berkeley.edu/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz"
    version "16.0.02"
    sha256 "02a3fe11994d3cdaf1d4bd5d2b6b609735e6823e01764ae83b704e02ec2f640d"
  end

  def target
    "x86_64-elf"
  end

  def install
    touch buildpath/"grub-core/extra_deps.lst"

    resource("unifont").stage do |r|
      buildpath.install "unifont-#{r.version}.pcf.gz" => "unifont.pcf.gz"
    end
    ENV["UNIFONT"] = buildpath/"unifont.pcf.gz"

    mkdir "build" do
      args = %W[
        --disable-werror
        --enable-grub-mkfont
        --target=#{target}
        --prefix=#{prefix/target}
        --bindir=#{bin}
        --libdir=#{lib/target}
        --with-platform=efi
        --program-prefix=#{target}-
      ]

      system "../configure", *args
      system "make"
      system "make", "install"

      (prefix/target/"share/grub").mkpath

      system "./grub-mkfont", "--output=#{prefix/target}/share/grub/unicode.pf2", ENV["UNIFONT"]
    end
  end

  test do
    (testpath/"boot.c").write <<~C
      __asm__(
        ".align 4\\n"
        ".long 0x1BADB002\\n"
        ".long 0x0\\n"
        ".long -(0x1BADB002 + 0x0)\\n"
      );
    C
    system Formula["#{target}-gcc"].bin/"#{target}-gcc", "-c", "-o", "boot", "boot.c"
    system bin/"#{target}-grub-file", "--is-x86-multiboot", "boot"
  end
end
