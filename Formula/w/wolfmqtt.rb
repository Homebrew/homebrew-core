class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "f8ecac43bb584a9250468dafb95b7db0bfb8c29a11715c7965183a092f75c3bc"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b6def8e092dc82188e26c18ed819887a40e0bce0ee108d0df4cd112c1de9148f"
    sha256 cellar: :any,                 arm64_ventura:  "d95196c3c8359b63f8001ec1c2dd5adc49afb42f563fb3794fa96931c5593db5"
    sha256 cellar: :any,                 arm64_monterey: "64d5170851160335587a2eeca5aa36510575cf0a42209798a2090070f747c1b5"
    sha256 cellar: :any,                 sonoma:         "a1b5c39f7d40b6a4d41522810e09edcc8a9d725f884f6424702d85feb1436238"
    sha256 cellar: :any,                 ventura:        "4240f54ef5095e0dfae0667978b44ed9bbccdf1529dad204245b8f4384e461ff"
    sha256 cellar: :any,                 monterey:       "39f71fbad4ccfc1182647302186c0cb7c8c1b53e8f6e57a5ada99ac414b98d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9564d23d1f5b2921f81987afb3ca07da1591ee6c656c6756f448a56649afdea7"
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
