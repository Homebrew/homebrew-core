class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "0df175741079bf7d82eb1a3f066df8741bcea9cd2a47b868ce45213bf5f3ff86"
  license "GPL-3.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c68cc59e6efc79036e2f1756c8a3434966c3d4913e5dc31a1185ffd0f10cbccf"
    sha256 cellar: :any,                 arm64_sequoia: "40dd75084a726bb260d2e95b48f57ecf83daa879bf48ab012775965a73fa0877"
    sha256 cellar: :any,                 arm64_sonoma:  "5d9ea945a0b706003eb6821d4e58b4aaa4d3ddc37ff0a3ea7476d97123dfe88e"
    sha256 cellar: :any,                 sonoma:        "9c752302eee055f1639d717b472927e091fc23e74899733030c725352cb90948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0b992d5b54de9e5b6ba169917e5e725b279ff9d5e54679abc67a7cae835450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "730d8b82f3577a377b5508e568214936ec43e03f81737958a768974d9fc9a1db"
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
