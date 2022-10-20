class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.9.tar.gz"
  sha256 "3e7bfe9345e7d196bb13cf2c6e758cec8d959f1b9dbbb3bd5459b004f6f65c6c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2b32393f9de620ec50c1a9d17eedd100ffa5dd3cb16a566a0deefcc85e77e5b"
    sha256 cellar: :any,                 arm64_big_sur:  "b2ae02794ae5a6c12b036519895f1c72ea6e05db9f69ed22323720d80e93f686"
    sha256 cellar: :any,                 monterey:       "14339e416c5e3ddfdd02e78a309978af0c9890129ab7c2b864ceb2ad894b091b"
    sha256 cellar: :any,                 big_sur:        "cecf89bc8f7c2ec67120c0ea806c3ef6315b942ec902b66ed2a707112ff7d339"
    sha256 cellar: :any,                 catalina:       "cccf50af7c95a6a4e6959a8ffbeb7f6b2e8c1a8b17ae9cb11ae61f4d074b28e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33c3b84c389bc9776a229b951849e9eade2b456a0f96358f4f973ecf6143e2f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
