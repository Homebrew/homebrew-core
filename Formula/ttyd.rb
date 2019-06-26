class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.5.0.tar.gz"
  sha256 "ae35d570e179f9a0e1b9f78485f5014450a1a87f982ff6933db9cda22f989d07"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "a4ff4b3815cfbeb102e2d072722a5283095b1b5387e76524bfcaf5e8827ad753" => :mojave
    sha256 "80feb44a31199cc5fc0508f27d629a91fc6d07fecb01405c2ba7cfea1f5cb094" => :high_sierra
    sha256 "c911748d585c7acb50e28d3e7ccb7f300f7bfb9e6c70471f7579d4fa40828458" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libwebsockets"
  depends_on "openssl"

  def install
    system "cmake", ".",
                    *std_cmake_args,
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
