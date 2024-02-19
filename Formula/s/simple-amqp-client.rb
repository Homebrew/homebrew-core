class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 7
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5955d47161a434eb00091e98b1627b7087e0289cf740ebc968ad6bc8c1a21d64"
    sha256 cellar: :any,                 arm64_ventura:  "f1197fa38e9b5f61e952b33523cd107d7b7a6ed46313ca3641aa92f8e8c54ad0"
    sha256 cellar: :any,                 arm64_monterey: "e021e1fa6187820eb9ffc9a52d3daa1ca070d855824471e9273c1e256411e137"
    sha256 cellar: :any,                 sonoma:         "cf2ae443a4777b7f154d39763e831d82e9bd33700ff9927cc6a949dbe7a39395"
    sha256 cellar: :any,                 ventura:        "78aab41f8651a59aec7ca1ce4ebb380a4761cd1502e30f2fc45abdbba895538b"
    sha256 cellar: :any,                 monterey:       "7828550fa8c2da040249a911fdea4d223978452eacd5d71b88f393ba8e88ff0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01b9a95164c0fe33252744f8edeb3250893ded1e2b62ec6b342ec75717b4fd0b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    # Remove hard-coded CMAKE_CXX_STANDARD
    # Else setting DCMAKE_CXX_STANDARD does not work
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 98)", ""

    mkdir "build" do
      system "cmake",
             "..",
             "-DCMAKE_INSTALL_LIBDIR=lib",
             "-DCMAKE_CXX_STANDARD=14",
             *std_cmake_args
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
