class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.0.1",
      :revision => "ae4740fa265701f494df23b65af80822f3e26a13"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "421c306cb72223499d1916857af9a6fd189083259df832651857f80a177bb563" => :catalina
    sha256 "925b5f0176c7264bc57bd4beceaa62e825d7beea40380d1e2e805ba70f5ebb38" => :mojave
    sha256 "91dd174a9c350ed0a4859ce906efe4dd1b1ea7ac82427fe0917d48d710bb2798" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-caf=#{Formula["caf"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-broker-tests",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/zeek", "--version"
  end
end
