class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/releases/download/v1.8/wolfmqtt-1.8.0.tar.gz"
  sha256 "1d57dd90a963d79a5ec58261392d14451665c59205bdc826082266ff1b5733f2"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e3e66f284473f7e646646a7383f41fe09a939b160151692756600f790755df0a"
    sha256 cellar: :any, big_sur:       "70cc3493f685ea09b9bda05688cfcdd9fb8dd7bbfd386ad1c4c6f58b29769dad"
    sha256 cellar: :any, catalina:      "495e994e80e47776f4f58c9e87a6b8cc74d0cc91abe4981bf1fca314e0d0ad83"
    sha256 cellar: :any, mojave:        "a6a39104cd27c320b7e99a303e191fca638a54aca69cdbd10b9ca9a8e26b8a8d"
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
