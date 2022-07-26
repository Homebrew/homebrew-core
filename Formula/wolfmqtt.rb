class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "23a073bfac172e08331ccdd01d9fb19e029fdcab5a8b4aad0e8dd4719ea97c31"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6743ba74e43132733f48d0ad5512e96a006484c42063ef11168fdfb9ec744ce0"
    sha256 cellar: :any,                 arm64_big_sur:  "9266b26a3369cf11ca96f47d0325c2ba2937d319494dc64a286d510c7ea86d4e"
    sha256 cellar: :any,                 monterey:       "05ce6791802d895f68ec6e264e647a15ca5418bcbc9473efa07c07223249044c"
    sha256 cellar: :any,                 big_sur:        "36ca37334d31a91f1fa38b364305fe55c4d2e4584dc6624cf0c8622125a3258a"
    sha256 cellar: :any,                 catalina:       "bd349db6c63df09b4ec0a096d3beb28e3c856524bde5915cad52810116e2f0dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05756095bc43bd7635dda05664a3acafd885920e4a01ae265751562bd254b1c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOT
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end
