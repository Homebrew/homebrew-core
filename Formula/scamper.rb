class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212c.tar.gz"
  sha256 "c04417aaf7eed717b88b49b7174bb5fb3a6e33da8f989523d110b3f6f37ff8c3"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7064583ac60ff14ebdaa49c9001a3e69aa804a42926cf4bb204b429799b5b962"
    sha256 cellar: :any,                 arm64_monterey: "8c892740e8054b23a59b1d318f6a6d91390f609baa7a30f2afdf7e36f8892431"
    sha256 cellar: :any,                 arm64_big_sur:  "b315c5f23d9d57216e10f5d2274abedcf6d592fd4ec9e65d6540937f51ce9167"
    sha256 cellar: :any,                 ventura:        "08f933279edb87a5d2ee7e85ac2e9f2bac05ef4cbb920b967021b1510e9af1c8"
    sha256 cellar: :any,                 monterey:       "42b924c4be834f5635fc47c4a4191933af61ff924ef452fc9cba870c82c53b92"
    sha256 cellar: :any,                 big_sur:        "6dfd07246543d6f70c43232123723dd569f016cc741d5479b5df3d690d655d6b"
    sha256 cellar: :any,                 catalina:       "2ed2dd89f1becb6561db3275dbfeb652b189559a5ca4c8a0f774e3800abacc18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "527f1218c888df8ae589ad0969bec6941edb9ddd10b0d261d4a99b2d4da7a4c4"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
