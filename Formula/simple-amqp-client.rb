class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 4
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4934679e7f98ae4e388cb49f4c792dfa6fc15b3f378996d779891eb811a312d1"
    sha256 cellar: :any,                 arm64_monterey: "e9a426101f4a78e56e72a7a96287f5a24eeaa6bb908007fb97939dd26191d02c"
    sha256 cellar: :any,                 arm64_big_sur:  "a32a157462250d92ed6966d105eaa94e68e1e5a5c7e4b3cf3be574147af3e181"
    sha256 cellar: :any,                 ventura:        "248986fba0e118f8300bc51df19c8297346c102f35881aabae4cb2bd85a1aa12"
    sha256 cellar: :any,                 monterey:       "0a77dcae6331e520082a3f22c921220729bf47a43b8465f619e97fa620d9d2b4"
    sha256 cellar: :any,                 big_sur:        "e97081c00960b37ae568859c3b7d74fd9b32c6df864738c437a112532a9e56c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b129d31f3201a601476be861313c9533bc771806fcfdb31b497d899494c44ad"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
