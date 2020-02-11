class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.0.1",
      :revision => "ae4740fa265701f494df23b65af80822f3e26a13"
  revision 1
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "db4d565aa97ae24e5dcfa252500eb5dedd9a01fe9b12ac75498eba3a1be8efa6" => :catalina
    sha256 "afa8d8b9d78ac1a21869422fe67eb9743a37a1c8359937ac7a3760b91d690824" => :mojave
    sha256 "95fd222759604cb74140d9b19305b339ac334221aaae83f2de4e3e6d7ff6a6a9" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "python@2" # See https://github.com/zeek/zeek/issues/706

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
