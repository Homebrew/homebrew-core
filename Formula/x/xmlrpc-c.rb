class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.64.03/xmlrpc-1.64.03.tgz"
  sha256 "74729d364edbedbe42e782822da1e076f3f45c65c4278a3cfba5f2342d7cedbe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9897b4b3c6605051e8e52bf360dd34ad7326c51d4463a9e57cbd5f619b8b0820"
    sha256 cellar: :any,                 arm64_sequoia: "9f09ab393af5042319150908090644ce6fbe8adaeecd9533c7fa4f4c6b411fb4"
    sha256 cellar: :any,                 arm64_sonoma:  "ffb5c8957883e25d1504134ca072965bc4b29634fa2d2a6e4436f6da2432f252"
    sha256 cellar: :any,                 sonoma:        "7d5a0807b77515d4adf986e490375efdff341bab63730ba19f5bb36f9df5db65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2251b02f8dca16a8ce8b03e5a648288f91819d6f90b3a7bc33e30f247a535065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3333ba125091b7c7852e8aad02a1f541aae8f6544eb5b41846101dca07764295"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xmlrpc-c-config", "--features"
  end
end
