class Wazuh < Formula
  desc "Agent and Manager for the Wazuh HIDS"
  homepage "https://wazuh.com/"
  url "https://github.com/wazuh/wazuh/archive/v2.0.tar.gz"
  sha256 "e374e836b847f0f4252ceb4a9e293916097605465db6f54cc4b59433e34f6395"

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
