class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.16.tar.gz"
  sha256 "4181c26f5b73b9d65eff2cce6d60d8a273034884a84686cb34e5c41cb2e9d7bb"

  bottle do
    cellar :any_skip_relocation
    sha256 "70930528cc6ae6e186694bc4de8b176b1a0eb42cf144be531753d0360929456f" => :high_sierra
    sha256 "9677d96c4bb20efe6dc7692f8b436efd983031e310a8bb2b63cd3ed3ab78e7ed" => :sierra
    sha256 "b6deb78ba081850f86c5f641799626be827b40db01257c3ab3680aa8b06baa9a" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
