class X8664ElfGrub < Formula
  desc "GNU GRUB bootloader for x86_64-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "a3bfac9b34a745e29d7ee88e5e148d6a4327b5b3b742db5be069adb39bcc1032"
    sha256 arm64_sequoia: "9e7f8e4ae40110b6b2ef9610497ecc11612f2c28c399ac3addf7587ddcb88284"
    sha256 arm64_sonoma:  "66784aa8aecb9d70cab2eefb31b6f21cd0a2e29b3325c958abed5288c257b2e0"
    sha256 arm64_ventura: "d5e9b928e26082ce63928c69575178c6deb912d36100ce95580b211c788b7f31"
    sha256 sonoma:        "ee6afc8a7dd71bded334efa01e9df5aa578093bde953a392939175e4092b83b2"
    sha256 ventura:       "6e256eb718661e554414730235ed267d15b10f928eaf8d47c27280a672321e48"
    sha256 arm64_linux:   "ad44fcab75cc08c82da70dc089b4a085dc2abf8c06dff9f8164fc16d98c239f3"
    sha256 x86_64_linux:  "e164e802fcb5d850632334568f4af43abd00561bc635f54f207aad940cb04362"
  end

  depends_on "gawk" => :build
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
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz", using: :nounzip
    mirror "https://mirrors.ocf.berkeley.edu/gnu/unifont/unifont-16.0.02/unifont-16.0.02.pcf.gz"
    version "16.0.02"
    sha256 "02a3fe11994d3cdaf1d4bd5d2b6b609735e6823e01764ae83b704e02ec2f640d"
  end

  def target
    "x86_64-elf"
  end

  def install
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"
    ENV["PATH"]=prefix/"opt/gawk/libexec/gnubin:#{ENV["PATH"]}"

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
