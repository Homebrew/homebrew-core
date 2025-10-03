class Secp256k1 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "073d19064f3600014750d6949b31a0c957aa7b98920fb4aaa495be07e8e7cd00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "befb6fbd1a71854d37fd02f7762968151bb6ce4d6a0246aea586d539a26b845a"
    sha256 cellar: :any,                 arm64_sequoia: "64b1307ae159f1e9506b976f0c8bb9c2864493da921c26a380f5630524e6687f"
    sha256 cellar: :any,                 arm64_sonoma:  "7b1a6a372671699586fb30bae9ebc3bf41fbcf68ba650667bbd68d119d767f7a"
    sha256 cellar: :any,                 arm64_ventura: "bf0148f53d69073acc33bd0ceee9c526bb91897a950f0541ec163d9a88a447b4"
    sha256 cellar: :any,                 sonoma:        "84bf45089a776dcf80f8721a6c64abacc1a10c591835cf53f2c9e485b395d8ed"
    sha256 cellar: :any,                 ventura:       "b4d7173aca17c79711e91884464731996d123d515cb616ac47802bc100e0d184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "211ac9db07ad07a3b656541f2cfa496cc7101f6c87089d586150adea62406e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5d0a7f12a90195c27beb544bf7856920744af124389d96ae177c507284e5aa7"
  end

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    args = %w[
      --disable-silent-rules
      --enable-module-recovery
      --enable-module-ecdh
      --enable-module-schnorrsig
      --enable-module-extrakeys
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c",
                   "-L#{lib}", "-lsecp256k1",
                   "-o", "test"
    system "./test"
  end
end
