class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 3
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81e37926ad2b168fada2fede3893e482c149b8eff7cc6545c4fadd0b0a9ab2f0"
    sha256 cellar: :any,                 arm64_monterey: "98e88b317c98418541f136c5a4258ac0a55811ab3930ce764f81b59cbeb2377f"
    sha256 cellar: :any,                 arm64_big_sur:  "0c8874f465e52174070b0458134ba72778c244297b482d34549823d353efd4fb"
    sha256 cellar: :any,                 ventura:        "de1ca3ebd077c11b64e08b03fe0721e644ef1ecca58b34b4f103ebed20a3d69a"
    sha256 cellar: :any,                 monterey:       "a2da20f175d9b66adc2b792574bc97f7ee52786c2c874a105fdc4a6ffdb3c09e"
    sha256 cellar: :any,                 big_sur:        "843b97c2ec5bc775a71375bee1890b6e64e11839965ea87d92fe90e575791392"
    sha256 cellar: :any,                 catalina:       "aca58f6eefbc489a0e1e5d630d888efc9116355485f7891ad5759e5b4db5deb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30d2f03df8695f2416b6b0882030f23a36754fa3da8a3815003fed880b44fea9"
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
