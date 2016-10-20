class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v#{version}.tar.gz"
  version "1.0.0"
  sha256 "938aa52ae96595d0370f4d6d13beb7b70bbea56434aecd6259e7ead2dd6f9050"

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "curl"
  depends_on "pugixml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "true"
  end
end
