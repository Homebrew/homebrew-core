class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.net/"
  url "https://github.com/freeswitch/sofia-sip/archive/refs/tags/v1.13.17.tar.gz"
  sha256 "daca3d961b6aa2974ad5d3be69ed011726c3e4d511b2a0d4cb6d878821a2de7a"
  license "LGPL-2.1-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "8df042b71a3fd4b2e8e98166acd4d8d79a59a9af94d268fdb4937d366b5d2207"
    sha256 cellar: :any,                 arm64_sequoia:  "c3097f4dedd66c5da27cea5bb43070acd0c131ffa1906cedcaed0c655600e808"
    sha256 cellar: :any,                 arm64_sonoma:   "18e0ab1bfa33dbb06af1169f0a7bdadd1e74513761079879a53eb2d23efb81df"
    sha256 cellar: :any,                 arm64_ventura:  "18af91a0199247226e541153739aafa4ba42b925f86b6519791ebed6a7c1bef5"
    sha256 cellar: :any,                 arm64_monterey: "26956b6d518f9e505bd877f40ec86d6c15f7a5731dc73bd42ea36e6e010da833"
    sha256 cellar: :any,                 sonoma:         "7ffb64cc2545893647c8ad56787b54ab291d062905531d3464c1c6b44178ca42"
    sha256 cellar: :any,                 ventura:        "2bcd26ac1b5a44ac629ae500e8663293ab5f83057c8962c5658c5dd9e844e9b0"
    sha256 cellar: :any,                 monterey:       "97692b921a654bc7844dbd80703b57cc93635b386514f73540cc03404381692e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e89732c82a0b6672d3e7a6be83c42ccfc3544f6011b13265ff4f25ceb8fa0670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5efd568019ef76ba684ed725b29f16e0a70f1fd08396b8dfd8660c7fd0367f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"localinfo"
    system bin/"sip-date"
  end
end
