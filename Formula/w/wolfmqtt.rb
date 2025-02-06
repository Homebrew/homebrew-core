class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "25a3ac5dbcbd94849640abf84d455a4fc76270b603b3fd2da1025daa257d8a70"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c6485268b58260c011050f127915913446bb769f3af16bdc9c32bcddcc8e46a9"
    sha256 cellar: :any,                 arm64_sonoma:  "ec5b48573a777523557c454637b45851fe97b606e124ab30777f8ab1f82e42bb"
    sha256 cellar: :any,                 arm64_ventura: "f96376285ccab96743f46e3dbfbf4d3ecbb11b31db6d3ad9aa85f985c37651b0"
    sha256 cellar: :any,                 sonoma:        "2c1591b8c8e24a9c3faf511cffd00e1523d6fe17c6f2fc76f5b01bb518802486"
    sha256 cellar: :any,                 ventura:       "ca399afde7599d41893b8ad601bcb4b2a524c5245c2ba3957ec43b0b09e50a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95256209db65977a6d26a8dcb915dcac4992982e41ed1a058fbabc0668708924"
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
    (testpath/"test.cpp").write <<~CPP
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end
