class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "38ded5114614a3514ac8bc5839b39b3cd6125088d04c324de9c9f33c1c13b526"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2657e71276bef863e848ba4adeacc81fc3a2a4e0536eeb6d9ce66ac5196a0aa0"
    sha256 cellar: :any,                 arm64_big_sur:  "b2de13c0ba6b6bd82cb1939ce8b3441ef50fbb1dd9c1fdff47d759ecd7600d0d"
    sha256 cellar: :any,                 monterey:       "02ad5aab4a1f524379cfc46991be2bf9457cacd27a20042863946a6a9ebdf89e"
    sha256 cellar: :any,                 big_sur:        "20506def8569a687ff99782c9834996cffff2ee19bf3c1d498b430c71578557b"
    sha256 cellar: :any,                 catalina:       "eb0afa9a69b790aa252ca7082b29c989bb50c795f5e6aa26782f5cc2ffdc0752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b4de029ff45036f2a7ca2cba99c74a26986b5228eed8283403b49985106b2e6"
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
