class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "e6b940d5da7bf3fa05ce07d8a2b7ea8604d524b7633fef51159d895cc3b3a1c4"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b40bafb5f54f7098e46dd06b265ffd5a622db91ab7ac7de8cdbf91b0d81a9af"
    sha256 cellar: :any, arm64_tahoe:       "e20283e43a6f81cbeb787b025b1981a33383ea14ffa6e97a7f962dd58af5486e"
    sha256 cellar: :any, arm64_sequoia:     "514ea3e89d2e5634547b123e6187112cbb3a4918f1d62d779360cd3fec3a2a91"
    sha256 cellar: :any, arm64_linux:       "32e2aa6dde49876552220f02542e449a321b25bd9858ef22206bd9e7f784d0a4"
    sha256 cellar: :any, x86_64_linux:      "90e23f5fc913b247be043b5ffb83ca05bcc8a9c9aab8e800fc38e5c6fa2fe2ff"
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
