class Xmlstarlet < Formula
  desc "XML command-line utilities"
  homepage "https://xmlstar.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmlstar/xmlstarlet/1.6.1/xmlstarlet-1.6.1.tar.gz"
  sha256 "15d838c4f3375332fd95554619179b69e4ec91418a3a5296e7c631b7ed19e7ca"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8da4979558af0c5679c2cadfac4c5a0a9f851eccd6a3ef74e0475b1dae7edfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c422e59ff501221aafa5679bcb5c83703f54c83768c0a144fc80d997b1961d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "355f3500eef2193e7a18e4fa465dda10c686690cb3118d60c644b2f09e9076f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "80f27cfee431b938bb3e4fadd7fc1a8dbe740ce1b00a053e6bee64441f7e5e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04a42fc41c21c9c4fb1483128c6a6be0ffe23ac31f181904aeb68cd12fe4dc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a94dccc66555dee58f477b358e98d91f5b9afff2c4385471ab19fb57c42e32"
  end

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  # Apply Gentoo patch to fix build with libxml2 >= 2.14
  # Upstream ref: https://sourceforge.net/p/xmlstar/patches/23/
  patch do
    url "https://raw.githubusercontent.com/gentoo/gentoo/ea0797e1f96c7a0e17fc1af24131a0e0c923d08a/app-text/xmlstarlet/files/xmlstarlet-1.6.1-libxml2-2.14.0-compile.patch"
    sha256 "5d2f35d16447e5d4258110a6e83f788ae52c9dc6b3b20eee84977626105dce1e"
  end

  def install
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
    bin.install_symlink "xml" => "xmlstarlet"
  end

  test do
    system bin/"xmlstarlet", "--version"
  end
end
