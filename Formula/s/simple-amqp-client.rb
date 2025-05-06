class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 11
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87ae8527d44ded5a0dd914f42d21527a951a01b9e99861413d73bc5113dbe74f"
    sha256 cellar: :any,                 arm64_sonoma:  "842d4ae9462815803fc55eb6ab9bd046edd63814df21bdd450e570e61fa14dcd"
    sha256 cellar: :any,                 arm64_ventura: "766942e45c1c85f8d93727b399a7caced4796226d67ee085b6bcf0c37a9a86b0"
    sha256 cellar: :any,                 sonoma:        "3692e9563b2f7eb144aa01de033003dacdfaefd9ae88a0bd5719c5519c430093"
    sha256 cellar: :any,                 ventura:       "386c44669e5e91bf2e33b954fe7d5abaf05e65c4f9329a36e1e5445f3d2bf106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724aaaf2f46fb7bbcf4d949fc115328e0e9108ee895048b1baef8f8453f4877a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f97c240551cdd21573e0a00f66fd23b6275b21247e718a93c05ff4185e56ad"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    # Remove hard-coded CMAKE_CXX_STANDARD
    # Else setting DCMAKE_CXX_STANDARD does not work
    inreplace "CMakeLists.txt", "set(CMAKE_CXX_STANDARD 98)", ""

    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_INSTALL_LIBDIR=lib",
           "-DCMAKE_CXX_STANDARD=14",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end
