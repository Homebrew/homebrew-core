class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.18.tar.gz"
  sha256 "d879f4f35ab7eae87486edc48b50f99a9af65f5eb6fb4427993ca578bb0e0dc8"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "18956eda0cbafea76d29ee0c4b034920afcacb9f8c9438dd6c3cb13254ff53e8"
    sha256 arm64_monterey: "59425f64ba486b7fe9aa011d73214e3f8c5f452d70a098e4ff9560521b8b4c12"
    sha256 arm64_big_sur:  "2bd6c22406a9926c697f92201aeb89c3ee2dc659a1b7f9fa6397ef06f8ca2005"
    sha256 ventura:        "54669c7c4c5ce414f4deceb5cf6e34a1a57c539ff540490163703889206f3452"
    sha256 monterey:       "ff0d745140fe3ae5b017e2101bc53c23a4f19c3130eca5aef6b045f4a1791a96"
    sha256 big_sur:        "27e2a8d50c546f3c3b8ca42f2f4db9e9df556054b311337e5b95dd2c3cc10e29"
    sha256 catalina:       "dc8cb72d30cccb2fbfe9300d1041107599b986d80d595970a8906acf5f7a742e"
    sha256 x86_64_linux:   "c1b4f3fbd1d7e4391353c06bf09d48d9fcd9c5741aac9e58c1e5eb222a74cb1c"
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"
    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    (var/"run/sstpc").mkpath
  end

  def caveats
    <<~EOS
      sstpc reads PPP configuration options from /etc/ppp/options. If this file
      does not exist yet, type the following command to create it:

      sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
