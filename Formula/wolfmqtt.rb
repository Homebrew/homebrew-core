class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "fdf6727da994eaea491b44d2db3e7f40cd968cb14db29191bf1f240e1e1ef81a"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fbbccc871914e2218ea6825597ebd726939f5115c61e0b54c96993b618d46961"
    sha256 cellar: :any,                 arm64_big_sur:  "cd5ab1f427678382887f63ed8391796d7144c161c84a5b0e6bda68173809dde5"
    sha256 cellar: :any,                 monterey:       "54b7dbe324e4a26a46d83298227223a8bceb54f7b46503b518b9278de961ec56"
    sha256 cellar: :any,                 big_sur:        "a29a7949afd165200cdb66b1031d80ae0caf23d706e2682e8c6bac3b58847acf"
    sha256 cellar: :any,                 catalina:       "2856e58fa5809a24b85633d13d9c2d7c76a750a0989cc63194b3775989381a3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed92de5ea87809d6ef9d9aeab01d83fea0caeb176fcd0e2a8477fb1a3b975305"
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
