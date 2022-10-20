class Uudeview < Formula
  desc "Smart multi-file multi-part decoder"
  homepage "http://www.fpx.de/fp/Software/UUDeview/"
  url "http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz"
  sha256 "e49a510ddf272022af204e96605bd454bb53da0b3fe0be437115768710dae435"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?uudeview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c72240dbc205cb79229af479b8dc1774b4eb11d0ffad47391102e033be4bb07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93a098dc40d16b9785888c20c8d1707a62fe471938c99ea8074df042548cfed7"
    sha256 cellar: :any_skip_relocation, monterey:       "0b5de5467dd832158645bca2006500fadaefc2e187819e883e9ff1a85bb60e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "94426299f928e2c7985194d2a3f436112b2ca580945eacc82ad5047c619c2417"
    sha256 cellar: :any_skip_relocation, catalina:       "9b5990b5b763e90614bd2d074e670c20e834541d60082a4e78f90d67a65da5c3"
    sha256 cellar: :any_skip_relocation, mojave:         "2869df0b09975172227dc83be6d667b3d0f8e4f2cf0f6d9ec0cd3fdca02727f4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7bb4c57755efed1b4208d234a0017d785757da04ca8f8e43c92980f3fe16b85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdd9748ec5c1baf9934bade72dd8a3eea06b632d0f1c49e57b682663bbb8371"
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
