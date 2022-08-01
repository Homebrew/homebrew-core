class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "23a073bfac172e08331ccdd01d9fb19e029fdcab5a8b4aad0e8dd4719ea97c31"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "66fc14eda504001802e840be169b42c9ebd5277e8398f1f3c6b847fd1759694f"
    sha256 cellar: :any,                 arm64_big_sur:  "4d2277007b418315f275aeff78509f9e457fccd637c1cbf037bfa6266d8a770f"
    sha256 cellar: :any,                 monterey:       "58511d1f1831e23450c04ea253de94eb574f562ccb861adbda9982405f3e4fd7"
    sha256 cellar: :any,                 big_sur:        "db56763b1dfb92c3b156957bafe799ebcad2e6f40616e85779a6e0fcd3697de3"
    sha256 cellar: :any,                 catalina:       "53dc13a3daff4b64e31044a8e6da20ac9e2fa66ac3aadffc15631b7b04e10873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4802e1a9d7c97da0d9a50af8d4fe03778cb31a721618538d2a4a711d2018a95"
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
