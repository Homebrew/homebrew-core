class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "f8ecac43bb584a9250468dafb95b7db0bfb8c29a11715c7965183a092f75c3bc"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f46a2b7c5f6719697cbeab120a572664aec85d6ec23d578b2adf48850c624361"
    sha256 cellar: :any,                 arm64_sonoma:   "dff16f2fbe2c26fe6722438d8ae234153b23898ae4a4933bbdec185d386c94d5"
    sha256 cellar: :any,                 arm64_ventura:  "66855c22567818428aaf8aa9ee7dbabb30b3fd8deffc638aeb8c664204928634"
    sha256 cellar: :any,                 arm64_monterey: "11f4ffd6c3f9427cbc6fc79ebeca21591ce3fe0eb2d9a71adfff61730e492d2e"
    sha256 cellar: :any,                 sonoma:         "0bdff7f693a3c30c1d9ba2080d3218ceb860493d4fcb92832e03ebfe048a6a6b"
    sha256 cellar: :any,                 ventura:        "12333823582936854312de0b5705953379289cfa18c844813909c816477422a8"
    sha256 cellar: :any,                 monterey:       "d9b1b3ee602d988570c5260ea0c061653c626df78ed527c8c9e52e12d54ab684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a203d97727e0c433e9ceacc1f72ed469a4c343a366b23bccee8110d5c7a6cb3b"
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
