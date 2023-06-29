class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.15.tar.gz"
  sha256 "846b3d5eef57702e8d18967070b538030252116af1500f4baa78ad068c5fdd64"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7bddb4c86e7ebba63fb28a1b28c58063765b2db268a6de5cb791488ddf4d63bd"
    sha256 cellar: :any,                 arm64_monterey: "617aeaedf2b8f9948198815950668ff13a5701e6b3ccc0531e16a27e6fa8ce4b"
    sha256 cellar: :any,                 arm64_big_sur:  "b3466a50ad11dae9dc53136e57eace7d511a7ea935dee5a0022bcae874d5fa14"
    sha256 cellar: :any,                 ventura:        "168dbd8adf7da0cd86e401c30146f27c6671f78c0c6af4e3c03554bc07f6c35b"
    sha256 cellar: :any,                 monterey:       "27c3a031519104338ace57c8c5e2ecd5a7cab74e624cd1f32d82ad0cecb2f3dd"
    sha256 cellar: :any,                 big_sur:        "c2274f89b8f065b42a300806366a6dc8f516f1b01037bd1caa16cbd7d2d4f9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cdbe7c8838184d52e61ba15923fc00b7e0b88f502f4d18ed316ee42dad822e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@3"

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
