class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.18.tar.gz"
  sha256 "fa56dd08649f51b173017911cae277dc4b2c98211721c2a60708bf1d28839922"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "920a01f591be96275e201cfd5dc6e34014cfe036cf255ad5c67daa3167f327e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1201de0e009993b46a273968cbcd8c9a43c468c30310807712052d398c7034f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6bdd57047af524d3efd157858a47d857a12fc110142a3d94bd47c8552fdc0a"
    sha256 cellar: :any_skip_relocation, ventura:        "cd8e00e27d2857404867233b70ccbe5f991ca50c03d9660533a0b60de47db438"
    sha256 cellar: :any_skip_relocation, monterey:       "a79b4c0a54e6b4454281c5f40a500e7f3923588815374f28684e9d0fc53adda4"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ce4eac19eaa6e7111d7ef7897595ac71ebb58f6d7da32dc309bb02bc5a90b4"
    sha256 cellar: :any_skip_relocation, catalina:       "ff92eb820b2efae9e87e42491a590601f400160f27ea2804b176b02b1648be66"
    sha256 cellar: :any_skip_relocation, mojave:         "2700f31ebcc1e2ba9219d6b6ac040846eba21ccc25baca4fea8b7d630b6673d2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "842ba6bbe666302bd39c1cf7d29caa7d5180c20757b8dfe91b99d3fe1d3da841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a295c834fdb6ae952708260a5a49bfd9771538ca5b6eda6014eeccaa1956dbbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tnef", "--version"
  end
end
