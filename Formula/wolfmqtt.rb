class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "f98b859364f74e87f42b3b6779cd70bed835443e2a45ae90197b215ca1578e7a"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f9a885cfc81eae83f860b441199361d6c4be22b09525c999d2b343cd21aabe4"
    sha256 cellar: :any,                 arm64_monterey: "5944c7de8a209415fce83848304fb5eb52ef5ea456d5767422924ed9554356c3"
    sha256 cellar: :any,                 arm64_big_sur:  "d6c0a61ad172d1390dfa03662320b7de0ca7697aea1325a58568ae615578b58b"
    sha256 cellar: :any,                 ventura:        "a91ad2b17de345a2034f6b28f764b3f92c7478ee86daa3940164d93c51b445e6"
    sha256 cellar: :any,                 monterey:       "c85509d3feec4dcf3c273052fdf70ee89231d5867bb519e695627a8518fdd622"
    sha256 cellar: :any,                 big_sur:        "01e48b7d95b583faee8b04830ea258c655df1e75902ba16874701b33d4135fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd279df91cd6dbd3ea88f5fd18225ade23e26e262524647a14be8690eb8a1ec0"
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
