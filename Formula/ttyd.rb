class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.5.1.tar.gz"
  sha256 "817d33d59834f9a76af99f689339722fc1ec9f3c46c9a324665b91cb44d79ee8"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "58ea695d4b89370c457af181fd83038414d226843b4e95ea5a55a9918287751f" => :mojave
    sha256 "546043d50d8545c387fb775f6e8635bee742e898db1ddfbf3ec1c7efeb562f1f" => :high_sierra
    sha256 "b6542250073ddcc031fe7347fa9613c7ac7cf3462bec0df97604e3e11b965562" => :sierra
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
