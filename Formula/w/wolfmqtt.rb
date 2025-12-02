class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3550e04e271cf6c0b8374a9ef8c26e6979a9a3d7473b48023394408e3a0e5bd8"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fad21d70156e12dbc52eb02a1468f874e89a628cb9ef76dbb65e098dd2991170"
    sha256 cellar: :any,                 arm64_sequoia: "b9897c68597eeeba48187bb4b3ca743529a406ce70b5013174fdc6f79f675ea2"
    sha256 cellar: :any,                 arm64_sonoma:  "cc5f1af1eb3409e61ff3e8a807e3cabf0e631d878756b361eaee19bc85c87dbc"
    sha256 cellar: :any,                 arm64_ventura: "ee4e1d293bc7c0514fe200e90cf4c5239b10683ae6131891761dbf559233a8a0"
    sha256 cellar: :any,                 sonoma:        "e08de62b1f3379411cf925bc0f0f3250519d027c32c16c00482136b4c1a66bc4"
    sha256 cellar: :any,                 ventura:       "e50a9d03d02a3ffcb2a3b9bc46526769ef826c01fc8a204f7bdb35ee594e538b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "705eb7f13a8c3c4571adcf7ec806bba4fffaaf9e56e62c50db093d2dbc0b58e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4638115b6a7755f4a496b3e22f5c0308c10636c1c9aaf59a5ebe67623a4e5c8"
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
