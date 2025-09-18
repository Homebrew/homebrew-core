class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "https://nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/main/cracker/sshtrix/release/sshtrix-0.0.3.tar.gz"
  sha256 "30d1d69c1cac92836e74b8f7d0dc9d839665b4994201306c72e9929bee32e2e0"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?sshtrix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "2bbdb14a7d6048a400de9bdc3a39ca12d50c462cc524158305ad93fc9bcd2192"
    sha256 cellar: :any,                 arm64_sequoia:  "a605f08172c039a927c317f64789c3168e610ed42ba321974e587db76906d546"
    sha256 cellar: :any,                 arm64_sonoma:   "6a48bc01574c09df7ade28b2cd6da48ab5df9966e670cdce99061a5231a832a8"
    sha256 cellar: :any,                 arm64_ventura:  "edd4114cab1117d380eb8614882bfd85fb00dd2c6a7b9ae2106a69774070147d"
    sha256 cellar: :any,                 arm64_monterey: "4ba3dc97f884fc7b76408c2f1686dfe6700dd7ccd742fb0dc7212aa8248a557b"
    sha256 cellar: :any,                 arm64_big_sur:  "bb7eefcc513933225daa50cac41e6216d890910f5bec5f0003c20e9205082608"
    sha256 cellar: :any,                 sonoma:         "6dab7f1e1122938f363c4f707acdd06bbc030e15ebd6c46fbaebd5beb1ae52c6"
    sha256 cellar: :any,                 ventura:        "aa50c681c419c3d327a58150f23b165e153a02a91a298a4439d0569313b99837"
    sha256 cellar: :any,                 monterey:       "e7ec4cd1d49778f4b708093a7e7b44879cd7b63426f7f917d4445400712e44f6"
    sha256 cellar: :any,                 big_sur:        "b3962b5211858eb4f6e1478665bfbb578c1f9d1c393237b841f9261aab4cdbf9"
    sha256 cellar: :any,                 catalina:       "e115c5a6f3378af5a0ab4297673bb7b659dd20054ab91d818b083ce13951e7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c4f3ba3dfdc9ed9b9b5d0453cb4110923890b27d038fa9c906f992a9d2bb8c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dfdb5cd8d621a41c636565b8e775d48e418feaf2f5a07dc773902d41cd13dd5"
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system bin/"sshtrix", "-V"
    system bin/"sshtrix", "-O"
  end
end
