class Speexdsp < Formula
  desc "Speex audio processing library"
  homepage "https://github.com/xiph/speexdsp"
  url "https://github.com/xiph/speexdsp/archive/SpeexDSP-1.2.1.tar.gz"
  sha256 "d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c794738735292d75e590ba371e29ac57fdfc465f712dd20823634a310759e824"
    sha256 cellar: :any,                 arm64_monterey: "f43bb5f238f0c3b74a4b08c09d4cc98c8935e77024f3c2e109b2683e5197f18c"
    sha256 cellar: :any,                 arm64_big_sur:  "78f624d4cb561115ca94e9caa71dc45f2b4227eb443245b7ae07674fb54bd81b"
    sha256 cellar: :any,                 ventura:        "f4dfeb2d0eaf57c871269de74f64df8ca82acfb72a1a81fd24698ab0309f3321"
    sha256 cellar: :any,                 monterey:       "b4d9cbbd5ad3e85630759fe8183c61fa94d772888c62f9a819b11b32ed1b7664"
    sha256 cellar: :any,                 big_sur:        "58d8bf8055672d3d7192c74a6381109c03507ea2ac11c0b1e40fd6b29c288415"
    sha256 cellar: :any,                 catalina:       "3499528f9bfb7c9a1bdff9d1da7f3de4c3dc5d54d25693e156592e76dec5f1d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c417e96a3739f41fb59aca0ceba32fd45b07f79175d8eda837dd125159098453"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
