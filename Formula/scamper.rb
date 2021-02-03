class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/tools/measurement/scamper/"
  url "https://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20200923.tar.gz"
  sha256 "dc9988d9a696152b5066f9d52dfc24cb898275b5c22a9f420cb901115901c324"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/tools/measurement/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0b528ce300490100119b8e361c9536089340455e22bc9f082c9f78927e8b3cf4"
    sha256 cellar: :any, big_sur:       "995fe1af6a105618af3ba11d8077df35ee30722f2305a358b88af1b3d56d0a7f"
    sha256 cellar: :any, catalina:      "827676f41de2c11b0d9919ea6d13048a2b8dbbeb83caf2d65649eb53743e4d45"
    sha256 cellar: :any, mojave:        "4633578193b5ce06e909adea554360f4baec3b3603634d38804287e74621ed04"
    sha256 cellar: :any, high_sierra:   "40b74e89b9a55f89761faa19a8c9509ccc81223f82433dee5f7f9a32f0caa502"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
