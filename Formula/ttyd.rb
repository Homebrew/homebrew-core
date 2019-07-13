class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.5.1.tar.gz"
  sha256 "817d33d59834f9a76af99f689339722fc1ec9f3c46c9a324665b91cb44d79ee8"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "1f59ccc12112fb81b6e3d77d0c5c929d8ac81dbba3c128eba6686142361c00bc" => :mojave
    sha256 "5247400ec27fd62cddac613c4eab51378bb8b495dfca280ea4dcf9ab02e67266" => :high_sierra
    sha256 "28cbaa7cdfb1a6bde640b4e00fd8b470bc73e99f7e4c9fa675727d83d4fd993f" => :sierra
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
