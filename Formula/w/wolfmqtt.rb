class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ddbf656e491ada58e04ee6cde1d783463675d7b134b5dd59ce451ce1daa5b0f5"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1d4bfd6962c2296878a692958040e0099adb6dcd5459ae243ec5ac88b13e53d2"
    sha256 cellar: :any, arm64_sequoia: "cff673a33e14ad4d69512dddd79315836da56f063b9262d69691eda5a7d2d305"
    sha256 cellar: :any, arm64_sonoma:  "60a24d9cf7d9431f4a688c0debd81c27c12f00403fc1cf94ff9ce5d99033df84"
    sha256 cellar: :any, sonoma:        "a69a56b7ea0356252f7a518cb64225c9a714ce5ee1c92fe26faf8de534426196"
    sha256 cellar: :any, arm64_linux:   "71cbd71f773d43614657ec8a520806541097b31b6897edf0b36b29691aec2fc4"
    sha256 cellar: :any, x86_64_linux:  "18c68231f6fae8abf2e51e159d469baa2232eea9ae8ca0d5e1f6eef656976699"
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
