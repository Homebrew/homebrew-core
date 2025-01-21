class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "77031b151092e8506d7c621f5e12e79531edca2336edf23146d3d72c70e6557f"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cc0ee01e3c1c852518ae34460393aa7bb635cd18edaaebbdc80da8111666227"
    sha256 cellar: :any,                 arm64_sonoma:  "de6d9d05fe702f19a5f2a08d843475098fd68469c1a7ff84c542d3a68439bd41"
    sha256 cellar: :any,                 arm64_ventura: "8ba8bd884b3c1a6181903d39e45828ebce5987ed16f179d2623aa55b8f4068a4"
    sha256 cellar: :any,                 sonoma:        "f50115d12168622e7c272f78b5038b37b5f06fa63e711dd79962ad1c3305ffd7"
    sha256 cellar: :any,                 ventura:       "e1c2586892699a4ec2adf9441950e1b6d0088ebeb31aa3944c0c9b6b9af2917a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a00efffceb07ebf6759f8a6756edad5696e2c8673bc31174f341711edf0dee"
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
