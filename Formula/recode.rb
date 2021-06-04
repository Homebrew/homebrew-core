class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.9/recode-3.7.9.tar.gz"
  sha256 "e4320a6b0f5cd837cdb454fb5854018ddfa970911608e1f01cc2c65f633672c4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9bca3845a8c324b5f9546c2c9de7881ee2a91b47513a39188fbc65d5c119b3bd"
    sha256 cellar: :any, big_sur:       "322571c853f461cd7f85afde9da5895996479b8aafddaa729081c10f4b319c57"
    sha256 cellar: :any, catalina:      "e049f7705d6f397a3a4bb87e31cc43eeb8ab7f0958b5efb3daccbab2a77aaa96"
    sha256 cellar: :any, mojave:        "27ba44840e12f588f741d2a7477ac8e6c6d3df22b09b426c617c87b98518d5c8"
  end

  depends_on "libtool" => :build
  depends_on "python@3.9" => :build
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
