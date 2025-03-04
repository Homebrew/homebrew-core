class X8664ElfGrub < Formula
  desc "GNU GRUB bootloader for x86_64-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "b76374ca36987f1bfef95216c14af606d263e17863df4d7b1a33b3cf65d953a3"
    sha256 arm64_sonoma:  "b5687ab4349a959b3bae9afb76103ab55bb5f0902eb199ab4aba00d974fc6c49"
    sha256 arm64_ventura: "406969f44c862754472dac117737965cf4c1ba427eba3ff478f0ce0bbfa75cc7"
    sha256 sonoma:        "a9e8fd25bd063a89080bee2e33d88e70fcd0227a2a8fb20e43e270d59062da95"
    sha256 ventura:       "e1770bd69fae7db684989eee7416337abb4f301a53a1034ab39efee73547cda9"
    sha256 x86_64_linux:  "c578c06b175f785718eafaa9e54c45bd767ba73a041cf1db73a72a6103573375"
  end

  depends_on "help2man" => :build
  depends_on "objconv" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "x86_64-elf-binutils" => :build
  depends_on "x86_64-elf-gcc" => [:build, :test]
  depends_on "freetype"
  depends_on "gettext"
  depends_on "mtools"
  depends_on "xorriso"
  depends_on "xz"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz", using: :nounzip
    mirror "https://mirrors.ocf.berkeley.edu/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz"
    version "16.0.02"
    sha256 "02a3fe11994d3cdaf1d4bd5d2b6b609735e6823e01764ae83b704e02ec2f640d"
  end

  def target
    "x86_64-elf"
  end

  def install
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"

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
