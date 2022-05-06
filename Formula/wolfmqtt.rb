class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "fdf6727da994eaea491b44d2db3e7f40cd968cb14db29191bf1f240e1e1ef81a"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "116d2d344c4d84e366acdfba68429f7b063b637ad4336a798a33b5e96516f23f"
    sha256 cellar: :any,                 arm64_big_sur:  "5d1b6c622566fdeecf98ae6aba2802ab5f4a1ec94572b6d79714164ac040c265"
    sha256 cellar: :any,                 monterey:       "38d2cd4ec1831dee9cf3ca1438ac4a0589e3bfe155cd4457ce1bb7fb844d5743"
    sha256 cellar: :any,                 big_sur:        "7bfe8733dc442facf67d29f53fad757fff4135361a600b7035fffb238571fd90"
    sha256 cellar: :any,                 catalina:       "3bcd431af7a2572da711cc4479f080cd3b70e2ef99017c487b997fd6137b7d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5447230b2e036bc2474f6dbd663586745655b7c143d8fb5a04a87ad9ed256208"
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
