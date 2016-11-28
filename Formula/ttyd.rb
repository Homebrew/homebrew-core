class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.2.1.tar.gz"
  sha256 "6f4f5e30d92ea1694ce528bdebb892a92aac5dda1ce13ea3b1ce7b865b971f85"
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "be09371028dca9ef32ae17e8d01a871ef4def9db01b9120c3ced32d00580b714" => :sierra
    sha256 "9e8955165dd5bcacae3529555fd085028dadd14a3957c7e623f96e3b0c6ff9d2" => :el_capitan
    sha256 "8b1ce8b931d0375b067d55f5dc1ce7f137f38bc5b3dee82a79e9de6f4e705a19" => :yosemite
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
