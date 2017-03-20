class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.14.tar.gz"
  sha256 "26cd7c1a91fa080b4a05b9e81cdee4af9fbd5c6cda44db5f112a2ae9b3c37bd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "f16d41879d9eb670fd67c74511f2aa6fd6f1e9cfd3d09f4cacd743c781414db5" => :sierra
    sha256 "8ad0c07995a560fa616d06dddb7c9441bf8801e3975e0930e848d2c6188d850d" => :el_capitan
    sha256 "e30a805ba061861a3ac3afcfe731c1b314402c93dd6a935f674d0459eaf225cc" => :yosemite
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
