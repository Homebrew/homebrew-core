class X8664ElfGrub < Formula
  desc "GNU GRUB bootloader for x86_64-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.06.tar.xz"
  sha256 "b79ea44af91b93d17cd3fe80bdae6ed43770678a9a5ae192ccea803ebb657ee1"
  license "GPL-3.0-or-later"

  depends_on "help2man" => :build
  depends_on "objconv" => :build
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
    sha256 "02a3fe11994d3cdaf1d4bd5d2b6b609735e6823e01764ae83b704e02ec2f640d"
  end

  def install
    target = "x86_64-elf"
    ENV["CFLAGS"] = "-Os -Wno-error=incompatible-pointer-types"

    resource("unifont").stage do
      cp "unifont-16.0.02.pcf.gz", buildpath/"unifont.pcf.gz"
    end
    ENV["UNIFONT"] = buildpath/"unifont.pcf.gz"

    mkdir "build" do
      args = %W[
        --disable-werror
        --enable-grub-mkfont
        --target=#{target}
        --prefix=#{prefix}/#{target}
        --bindir=#{bin}
        --libdir=#{lib}/#{target}
        --with-platform=efi
        --program-prefix=#{target}-
      ]

      system "../configure", *args
      system "make"
      system "make", "install"

      mkdir_p "#{prefix}/#{target}/share/grub"

      system "./grub-mkfont",
        "--output=#{prefix}/#{target}/share/grub/unicode.pf2",
        ENV["UNIFONT"].to_s
    end
  end

  test do
    target = "x86_64-elf"
    (testpath/"boot.c").write <<~C
      __asm__(
        ".align 4\\n"
        ".long 0x1BADB002\\n"
        ".long 0x0\\n"
        ".long -(0x1BADB002 + 0x0)\\n"
      );
    C
    system Formula["#{target}-gcc"].bin/"#{target}-gcc", "-c", "-o", "boot", "boot.c"
    assert_match "0",
      shell_output("#{bin}/#{target}-grub-file --is-x86-multiboot boot; echo -n $?")
  end
end
