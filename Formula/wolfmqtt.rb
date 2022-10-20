class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "43f76ca5116bef9b611233c8e1612fc88fab9380da1dbd50f64d64987eb3bea2"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d35827e9a6c1c25056fd77fd25a8cde36c66e49871fe9d80620432af8b1a152f"
    sha256 cellar: :any,                 arm64_big_sur:  "c34ebb971b2ea174ee619f4df84646aa7ce59bc7c2e0f4910014edc77e4539af"
    sha256 cellar: :any,                 monterey:       "7bcb9c674ea856ba255a340713615e9f974f2c353a85e05a3130c2226f1fc594"
    sha256 cellar: :any,                 big_sur:        "ba94aace1a5ecacc837e9322fc05d9a4dc13cddb8b086135c16c8b9d1c2f7a90"
    sha256 cellar: :any,                 catalina:       "060c72bac54d786ff9ea0439c6162234674076da7774bfb810ebe890f5a87b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "734caa729560b7916f23aeff02288aaed1f588da0c91af981f8c986e9a3a2d25"
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
