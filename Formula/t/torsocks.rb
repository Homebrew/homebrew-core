class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitlab.torproject.org/tpo/core/torsocks"
  url "https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v2.4.0/torsocks-v2.4.0.tar.bz2"
  sha256 "54b2e3255b697fb69bb92388376419bcef1f94d511da3980f9ed5cd8a41df3a8"
  license "GPL-2.0-only"
  head "https://gitlab.torproject.org/tpo/core/torsocks.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "b5d5931945d4eb5f2fd28481d2498492f2de77e987d3d3622008281f9b40ca01"
    sha256 arm64_sonoma:  "a8da2ce1c5139f9ead58af8a1ba51e6938bcd6073440927b37c0386238b28a73"
    sha256 arm64_ventura: "af12596e6a8e4f4c4ff3fe6e78bdd10208a2f0dc6d7febb4e07045849b197b6a"
    sha256 sonoma:        "895ce81c30fff7067666ab08c5e57fbc5f1d15fea84d5afb5439842a487a0675"
    sha256 ventura:       "b028a43bbf38e062a4fae15d77d681a3b5a09ee9bc80076d28113276d74fc9dc"
    sha256 x86_64_linux:  "162199d0f4d1f3419971ccac67db06cb27a50358d39b304f6098e683f4b2b935"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://gitlab.torproject.org/legacy/trac/-/issues/28538
  patch do
    url "https://gitlab.torproject.org/legacy/trac/uploads/9efc1c0c47b3950aa91e886b01f7e87d/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"torsocks", "--help"
  end
end
