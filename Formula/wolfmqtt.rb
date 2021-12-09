class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/releases/download/v1.10.0/wolfMQTT-1.10.0.tar.gz"
  sha256 "9a708c0339e03367be5001fe9c261602b3a1aeaaec51cc773f71fe7938436831"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5fd45c0c12885322366dd48e128d2398325738f4862045e830679db832f190f7"
    sha256 cellar: :any,                 arm64_big_sur:  "9a877507939c589ae6a8c03584a1f6a020219e113706e9f14eaf67728e665ae3"
    sha256 cellar: :any,                 monterey:       "b2b046ca78acad78409dc37d8e753179c69455587969c2aace8ed4b57c314be6"
    sha256 cellar: :any,                 big_sur:        "ab9009a72b8836d98bdf4fb032cc040199e572b9a61a850c78f8f7a90723ea0e"
    sha256 cellar: :any,                 catalina:       "c20e5751fbe8873ac317b5d67bdb8089c529b1c4835e10008eab4004c816f608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc65447c9e60d9021532c9229e60c6c59ae9f31a8992176d2599e1b490c50b5"
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
