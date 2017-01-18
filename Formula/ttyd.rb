class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.2.2.tar.gz"
  sha256 "6e85335c11df68e6401178269920a586bce7e66045bd0b225f6d2bc58356d105"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "50197b7c272492dacd530e04429abbc27ce93d1308cb46f3dc0d8e156b90c1ba" => :sierra
    sha256 "d8900736ca9c170bbf1c7040e1d9eb09b7c279b51ed217481bfc70b91ed2a269" => :el_capitan
    sha256 "601490338c4f099e63bed009778f163ac0409940b2418d07b91288637b9966e1" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
