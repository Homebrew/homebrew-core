class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/releases/download/v1.6/wolfmqtt-1.6.0.tar.gz"
  sha256 "ddd61f977714ed56c7a1c8dbe061408a9f38e206e28162934d3f40bd07c18879"

  bottle do
    cellar :any
    sha256 "69cad59befccc596b031061ae8d43f06395e92b9a870f79d3c326abd63aab801" => :catalina
    sha256 "d87c755ee5f7b7502f188abaf3f8ddcd88b394fe056f5912edfa9c98db3718e0" => :mojave
    sha256 "7cd884e7105e3522b767bafce562730e8279c511be71a0ef223f16c2120b03b4" => :high_sierra
  end

  head do
    url "https://github.com/wolfSSL/wolfMQTT.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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

    system "./autogen.sh" if build.head?
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
