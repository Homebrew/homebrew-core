class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "https://sstp-client.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/sstp-client-1.0.14.tar.gz"
  sha256 "e0eccae251ab7264cabbabf3ec8d45ef981187684c9ef34613bf5f70affe10e7"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/sstp-client[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "82b2a0b491752d77b6d47a0a4fc1cffe0656e0a04a5e49f2a6802f9b302378c0" => :big_sur
    sha256 "a67f8784f0a716ed85a181bd5010b9f5ca700f0f44a107dcaf78560ba349e876" => :arm64_big_sur
    sha256 "014b4af9e8f774591bb335fc49b2f010bf54cade6149dc0367cabee0a604f5f9" => :catalina
    sha256 "060f97c76ca3086fc58ab20be2dad388a1299e4731f4571bca9d807f168d788e" => :mojave
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
