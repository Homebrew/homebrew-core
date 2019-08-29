class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.7/sipsak-0.9.7.tar.gz"
  sha256 "e07f32e692381d9db404d75868218b553e0aba414d35efc96d13024533a53f0f"
  revision 1

  bottle do
    cellar :any
    sha256 "20c81bc83de9456d6bef1a04e2782c8c0a4898151f063c716077f7159a5dff24" => :mojave
    sha256 "908c57962d3cc43847b4048db06a291437756fd8da691a7703f5285776fd2d78" => :high_sierra
    sha256 "28b6d28bfdc537cea588ebe947a0e98833c052e0eaac31b2a672d23e121894ce" => :sierra
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
