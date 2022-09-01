class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "43f76ca5116bef9b611233c8e1612fc88fab9380da1dbd50f64d64987eb3bea2"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec59fe07c81cebcefca5f84bf4eaa5dadbd7bbc1bb7e67f58936886e05d0f8c2"
    sha256 cellar: :any,                 arm64_big_sur:  "e63498f832d0fdfb16fb12fa750aa552f8abfbe3eecd45efbb3547e5c15a6b6d"
    sha256 cellar: :any,                 monterey:       "b75dec93dfdc8f785ea6f4260aeabc57a16bbbc4930d19e4caf91a59369eb7eb"
    sha256 cellar: :any,                 big_sur:        "e939570bc9f65a7df18e928ba535de1933086f51176d58aa0b1f36084a50d88a"
    sha256 cellar: :any,                 catalina:       "620a99be33560c5300398c3ced6370a75ed9af044de1471f500822b73eae7492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23df65d7dc4404cadb1c2c4a099b00a3bfc67b0300285288802bd1d26acca385"
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
