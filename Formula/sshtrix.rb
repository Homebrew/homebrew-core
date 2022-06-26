class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "https://nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.3.tar.gz"
  sha256 "30d1d69c1cac92836e74b8f7d0dc9d839665b4994201306c72e9929bee32e2e0"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?sshtrix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ba3dc97f884fc7b76408c2f1686dfe6700dd7ccd742fb0dc7212aa8248a557b"
    sha256 cellar: :any,                 arm64_big_sur:  "bb7eefcc513933225daa50cac41e6216d890910f5bec5f0003c20e9205082608"
    sha256 cellar: :any,                 monterey:       "e7ec4cd1d49778f4b708093a7e7b44879cd7b63426f7f917d4445400712e44f6"
    sha256 cellar: :any,                 big_sur:        "b3962b5211858eb4f6e1478665bfbb578c1f9d1c393237b841f9261aab4cdbf9"
    sha256 cellar: :any,                 catalina:       "e115c5a6f3378af5a0ab4297673bb7b659dd20054ab91d818b083ce13951e7da"
    sha256 cellar: :any,                 mojave:         "a54f2c867dd6539824cc69888975d3cd2041b4b922183262d29fcdf655391cfa"
    sha256 cellar: :any,                 high_sierra:    "dd567f106a7fe8a7a6f9e2474b284109e1dbcb14ed847163d1f65f4d69467f93"
    sha256 cellar: :any,                 sierra:         "dafb3bc8c14e729cbbfbf8dc6a9ce789e01732a644aa84b243af24f2bd92ce19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dfdb5cd8d621a41c636565b8e775d48e418feaf2f5a07dc773902d41cd13dd5"
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
