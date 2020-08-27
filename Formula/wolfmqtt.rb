class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/releases/download/v1.7/wolfmqtt-1.7.0.tar.gz"
  sha256 "fd9aa74e4c7ad4fec8f2d4c40ce32785b5bb55d7c013c5acc846062583f09a9c"
  license "GPL-2.0"

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
