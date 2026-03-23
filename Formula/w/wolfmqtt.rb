class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ddbf656e491ada58e04ee6cde1d783463675d7b134b5dd59ce451ce1daa5b0f5"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fff3eba4a8f27e7499aea5e907056a0b426a7fb37e4b6a42e6d973706afc6707"
    sha256 cellar: :any,                 arm64_sequoia: "ea2baa494710479d90c4f5b53ba98f827f54ab77be899aac2b894a0d7361d601"
    sha256 cellar: :any,                 arm64_sonoma:  "0547bb45ff40f0ad99677a9bb38227f07fa09216b1a169f856cf6fc6ac6d1d5b"
    sha256 cellar: :any,                 sonoma:        "759b90e07d98503c6419d7bee4aeda2b4bf86b3fe62f30b592c67f7c6e76ad6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c8e3ac7fc1f23a804746f1fd156b682603af2112efabb520548c937c909b09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6a06c4d763ac4a9191e805f4f14418fa151c85138f636991b7dca032a1d5a4"
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
