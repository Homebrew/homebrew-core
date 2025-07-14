class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3550e04e271cf6c0b8374a9ef8c26e6979a9a3d7473b48023394408e3a0e5bd8"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3d2b86e04932ea20a3603fec126e9f4bc534d6bd1489b6de71a5a84f3e631f0"
    sha256 cellar: :any,                 arm64_sonoma:  "fa65aa7f49bb183268bb1985c90174d7df5c4ba047cfdf3102506e88440f3000"
    sha256 cellar: :any,                 arm64_ventura: "35d82d87dae115b8d91b80658d0e2b52c1eac6719d6be84413650dfb65d9aa5d"
    sha256 cellar: :any,                 sonoma:        "9b7a5bd35524cd73cc377e7ead2a7014cc07622a2c0f1150b560b5f68cd0fd96"
    sha256 cellar: :any,                 ventura:       "194de1f1645892c588d90bdb34ad87fa5fb77aa7d965847e720e394228dd433c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e1f05cab22ad6fe447a5ad5328c8243f926c32d0c89e1f456ce44c6a747226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971a4a2540cb3166c46fdc030f256862c2ee8b66a476de654ad5ae781433609d"
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
