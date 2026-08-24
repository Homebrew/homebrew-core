class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://www.wolfssl.com"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "abfea53ef25678a540f9b44aceb4aeff3f7789d7b23454074471c8e8dbcb4ccb"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "906f1f132056faef3d98b7b8b8d78d9c7aa114f1665004ac84429a9527894e40"
    sha256 cellar: :any, arm64_sequoia: "e34e4cc010f6b5e61eed9dfe972da3fba4bddfc2bd1e2752905977f3793e15b1"
    sha256 cellar: :any, arm64_sonoma:  "c55b48a15c74be43f6de8656e90ef5e1803e52cbfb08087abe1d69fff4b83f69"
    sha256 cellar: :any, sonoma:        "478f70818690688a593270998b98fd02d09150b31950a75227e8f50ca66e3db9"
    sha256 cellar: :any, arm64_linux:   "4d2cc1b55fe3e778a1e75caf017c80586dbae70df6aee982cd70dce670f4e461"
    sha256 cellar: :any, x86_64_linux:  "35d88b8187d6264795fcf002a072ab28ccd12b6755079d0b2fb3222d2e6dc0e2"
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
