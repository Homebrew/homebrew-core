class SstpClient < Formula
  desc "SSTP (Microsoft's Remote Access Solution for PPP over SSL) client"
  homepage "https://gitlab.com/sstp-project/sstp-client"
  url "https://gitlab.com/sstp-project/sstp-client/-/releases/1.0.20/downloads/dist-gzip/sstp-client-1.0.20.tar.gz"
  sha256 "6c84b6cdcc21ebea6daeb8c5356dcdfd8681f4981a734f8485ed0b31fc30aadd"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://gitlab.com/sstp-project/sstp-client.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "71109b298ce186a8e26fde8fc8b7ca10e0a4608452b3065cb43aded5d1927fcc"
    sha256 arm64_sequoia:  "ff9e147017fa32a2f65c2ec46fdca292e7e92f3bb7cd6bdfa5d8ef77b34acf82"
    sha256 arm64_sonoma:   "4c4f9aa5820641e408e0106b9db844be89615c289b52ca07c5e421b157a1a4c6"
    sha256 arm64_ventura:  "26446c059cd275fc49d4f4475757f2a700ecef734fef50e99d55e352f4c04c93"
    sha256 arm64_monterey: "c6d91a90c2988a96b4be0ea9ce0120944471c0164ea8052fb45356710fbbf8bd"
    sha256 sonoma:         "184766c884ccf2bd80dd683a219ceb022038474b7a620e2c3ce496625c1302ed"
    sha256 ventura:        "d1cf3956def117437343e10197b14bcbc03fd6a2dc96278b5036f2153085dc09"
    sha256 monterey:       "015cfdcec2002f2c9ec54e06d070e86c28222f776ef651625f255ff5238e0a5c"
    sha256 arm64_linux:    "d6025e73684a9bc136b059d9339b385c0d57ea8f9e3dbb311b468b90c051878f"
    sha256 x86_64_linux:   "30078ed4805a4e3b52753c60ad87590d21a8a5289b31fde3d27be0116f179b2b"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "openssl@3"

  def install
    system "./configure", "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--with-runtime-dir=#{var}/run/sstpc",
                          *std_configure_args
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
