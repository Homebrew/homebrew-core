class Uudeview < Formula
  desc "Smart multi-file multi-part decoder"
  homepage "http://www.fpx.de/fp/Software/UUDeview/"
  url "http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz"
  sha256 "e49a510ddf272022af204e96605bd454bb53da0b3fe0be437115768710dae435"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9b5990b5b763e90614bd2d074e670c20e834541d60082a4e78f90d67a65da5c3" => :catalina
    sha256 "2869df0b09975172227dc83be6d667b3d0f8e4f2cf0f6d9ec0cd3fdca02727f4" => :mojave
    sha256 "7bb4c57755efed1b4208d234a0017d785757da04ca8f8e43c92980f3fe16b85c" => :high_sierra
  end

  # Fix function signatures (for clang)
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/19da78c/uudeview/inews.c.patch"
    sha256 "4bdf357ede31abc17b1fbfdc230051f0c2beb9bb8805872bd66e40989f686d7b"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-tcl"
    system "make", "install"
    # uudeview provides the public library libuu, but no way to install it.
    # Since the package is unsupported, upstream changes are unlikely to occur.
    # Install the library and headers manually for now.
    lib.install "uulib/libuu.a"
    include.install "uulib/uudeview.h"
  end

  test do
    system "#{bin}/uudeview", "-V"
  end
end
