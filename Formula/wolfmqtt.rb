class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "5d0c14ff0c5c571907802f51b91990e1528f7a586df4b6d796cf157b470f5712"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41814c2573b16061ff0f997063b5662418e267d00a45f67ce9294219fae94c3f"
    sha256 cellar: :any,                 arm64_big_sur:  "ded91f6729d83cdf7122b79534326d480416b6aace5223e2ce4a3235b49d75c7"
    sha256 cellar: :any,                 monterey:       "ff77fbd5bd48a2db0e5196925109d3cfb37d86a60ff97c8a3353e003b2a0e135"
    sha256 cellar: :any,                 big_sur:        "23575090380bb2d04015ba571e12c0a1f94958543389fb746822d7c7456f55e3"
    sha256 cellar: :any,                 catalina:       "64de89e504b10f918f9de2caf4c1742a1f8942500c7af9c5267724b58c01deb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c829fe3a132623334e46eeb6b22c25e645d4199d0afdd4b2a9c9272564431f52"
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
