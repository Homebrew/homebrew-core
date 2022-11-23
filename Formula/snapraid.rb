class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v12.2/snapraid-12.2.tar.gz"
  sha256 "9d30993aef7fd390369dcaf422ac35f3990e8c91f0fb26151f5b84ccb73d3e01"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a12c659bfe1a8ee981eb3bfae72b2d8ba469cb411a2596d856537a1ace55788"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b915f177268a0caf218c61839f0094fbce74d1ce02a8fd91c0f5be947e0a4ac2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d61d8bd872a854145c3204dd03b15ea5975437bf6041deded16a724449374a6"
    sha256 cellar: :any_skip_relocation, ventura:        "38c6ec82977fd77980a5bf3883c41e1f95236223385b10aa7345504eea522e79"
    sha256 cellar: :any_skip_relocation, monterey:       "34530bba9f9d233b699c4b618190d09e245eedad765bf790b0aee213f5c6907d"
    sha256 cellar: :any_skip_relocation, big_sur:        "73bb540ade6633bc5483250e534decb865ff205c7df5662a854c6edb05d181d6"
    sha256 cellar: :any_skip_relocation, catalina:       "d3075caa16f4fc7afc551656065590b94b251268f16fa4d023594b070f0732ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262bb8b67f06eb4d938c5fa2554a2dcd8142ef545b0a62c625e237a0fad77bcd"
  end

  head do
    url "https://github.com/amadvance/snapraid.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
