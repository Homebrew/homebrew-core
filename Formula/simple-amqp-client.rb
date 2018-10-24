class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://github.com/alanxz/SimpleAmqpClient/archive/v2.4.0.tar.gz"
  sha256 "5735ccccd638b2e2c275ca254f2f947bdfe34511247a32822985c3c25239e06e"
  revision 2
  head "https://github.com/alanxz/SimpleAmqpClient.git"

  bottle do
    cellar :any
    sha256 "ae17788dba33efa3b41cb14ded5b483689002cedbf00693a8e348f3236ad759b" => :mojave
    sha256 "50bbaa2902d2893692e28465666f39405ecd4481e37fbbb5b99d2ef7d3690bfa" => :high_sierra
    sha256 "32ae102c9883a9a6464084284d34371e6538c75fdfbcd1f8230e9889be4a2956" => :sierra
    sha256 "b2ea2a0ed47a8eff9498d3e90fd01e5e466cc1317515a8fa63b6262d88af6800" => :el_capitan
    sha256 "4ce0051362b24556e552aadf852dc98910414ff9ed81d9c9efbbeafb863c8cb6" => :yosemite
    sha256 "37b12090418d4423810cff30c484d0a11736bf856119e9757d9923a381db61bc" => :mavericks
    sha256 "92986f1969aa18e48035b57dedcaec0bf5c098f597b8fa6d573112e4d266958a" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
