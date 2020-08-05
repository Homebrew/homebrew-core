class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.7/sipsak-0.9.7.tar.gz"
  sha256 "e07f32e692381d9db404d75868218b553e0aba414d35efc96d13024533a53f0f"
  revision 1

  bottle do
    cellar :any
    sha256 "84d9694858c95f7ce07829e602be3d9727b00602ea69bf8e191f79f399f53597" => :catalina
    sha256 "5da0bb6fc866723e423714b275cbc6c64ac1e57f171cfe112bda6f9779385ae3" => :mojave
    sha256 "6cc0007fe520e225bc0a6b9b646817468acbc1383cb6a4382ae8bf1243ae3e5b" => :high_sierra
    sha256 "0d074a6356f127485211b79741fd7f45e7ed9435e4d708e539088a9e9154daea" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end
