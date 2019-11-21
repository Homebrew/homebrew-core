class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://github.com/bro/bro.git",
      :tag      => "v3.0.0",
      :revision => "a5557586699d9a90aba70a7a0468549c400e9b61"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "41f94471321f660ee0cb1f0577f6501fefd5d5af4959db475450ec12cbf2c658" => :catalina
    sha256 "efac6ba7610a0b6b72be5308a245964c2b5b82b86fe34fd5bbdc541ad25128ba" => :mojave
    sha256 "392fc82e858a89e5041e7d3e016353d1b056ed9a73de48a8c5d2952124d13f57" => :high_sierra
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
    system "#{bin}/bro", "--version"
  end
end
