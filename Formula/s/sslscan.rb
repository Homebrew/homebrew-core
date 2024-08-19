class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/refs/tags/2.1.4.tar.gz"
  sha256 "3e2a5b1f53d1f132b4d999ff450d2cc40e9efb648cea89b74f5944b768a10e63"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fccbdbc8cf90e71ed2c506706b06d9471c68937e1c5e687b4b1387b3fec130f7"
    sha256 cellar: :any,                 arm64_ventura:  "4f9d17ab876d54b6f18ea2c640104b1999c6cd87f1eaf4a10afd42ff19eb4df3"
    sha256 cellar: :any,                 arm64_monterey: "ed0df35dd2a730ed94ca21c866ff415191e6a83fad26874cd36fee8b6ae0533c"
    sha256 cellar: :any,                 sonoma:         "ac7337ebcdf307764ce659add900de802ae599b014a877d2234f294abaa45c78"
    sha256 cellar: :any,                 ventura:        "8fcabf2b9655997cac59b624bd210ec328e73660c83a5eadf273c54400d18eec"
    sha256 cellar: :any,                 monterey:       "90f1d17b454ff8a8b9a31045cf7a9eb82db1c67d7ca45806ed62d7b5f364227d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a45abcb53b9be93a3af6302efb05dae2b2d6dda4c86319266ac4798abd3d367"
  end

  depends_on "openssl@3"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sslscan --version")
    system bin/"sslscan", "google.com"
  end
end
