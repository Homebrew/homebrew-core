class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "5d0c14ff0c5c571907802f51b91990e1528f7a586df4b6d796cf157b470f5712"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3c024785eb3879f403446a0dfae371d018541fce5804e5c9edd2dccfb15f6488"
    sha256 cellar: :any,                 arm64_big_sur:  "5ae9429d95474b88c306e08834444d21a9bb7882d1baa73473ebad127d74e2b8"
    sha256 cellar: :any,                 monterey:       "d8c667c454d521d650c4743788e64dde2eec17e127a10a312e59c8d374e89346"
    sha256 cellar: :any,                 big_sur:        "d1e7334a01a13006f5e00b3529d195724e583146b76ed1720e1357450b6fe57f"
    sha256 cellar: :any,                 catalina:       "b62b1427ad39b8df8dde41c7105bd4f3101ebe08b6a78d18e71e20f85f76e7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc88e56d750ca7f945b6c8aa6af7118e434c057c1f894cf162d19aa0bea7148"
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
