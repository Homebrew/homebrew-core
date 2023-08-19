class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "be806967ff4dfa80d88d2197cabd8a5bf0072d03759bf8506aaa4ee9c5c48ba6"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "49b23940a62dcbe6e66e5338c89faab6f4db51bd1126be29dace74b70348d411"
    sha256 cellar: :any,                 arm64_monterey: "c4df8a877f40d52d69fa5d5016751db51be85bbfbcb79e927bf8a03fc42c3b20"
    sha256 cellar: :any,                 arm64_big_sur:  "2999a1f462c8b195135d88258f36633b2c20792172927f70526b133cb93587ba"
    sha256 cellar: :any,                 ventura:        "8773446a50beb3494efed336b307bdb03532c72eba3864397514874523e8a5f0"
    sha256 cellar: :any,                 monterey:       "b5fe604ffafc2920cef29d3fbc5d010d2011375c18ca47798894bba837803719"
    sha256 cellar: :any,                 big_sur:        "9c5336dfdc4c7c920c91a9b3138b77ff531985c82dca4d0ee6faab40ae393981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7418f88c7422585fd8078c1c06d7f77c4dcbb46e137d96cf7258eaa395d5902"
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
