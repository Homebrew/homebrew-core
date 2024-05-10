class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.2.2.tar.gz"
  sha256 "468c2d6cb4095e581927005a1dab13656f5a9355e4c68a3a25fceb5c6798a72f"
  license "EUPL-1.2"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4116feb76d22357c68e8c5a08ffef422c0e01c3b60aabeef4e3b4f05839a62a6"
    sha256 cellar: :any,                 arm64_ventura:  "b3507667a57c0d40ae48bab7c5e9dcf08cb0e17030a20b3f3d746973bbb8193e"
    sha256 cellar: :any,                 arm64_monterey: "a8afc4ddc4a4081a00908f94189611a642eb9cbf6419b41bef7db291960ad250"
    sha256 cellar: :any,                 sonoma:         "426da29c687af12a8f693ad486f02a4fb7a1f6cca60416bb6715a536c5d62ffb"
    sha256 cellar: :any,                 ventura:        "8bd9e8528e663ba4aab929be622df0830433aa554c0c133e131350d507c3f539"
    sha256 cellar: :any,                 monterey:       "6dac6669b4d4b2fd9af0bde77fcd4ae7e5187ec8801eb0e26b7fa8796f8b3e1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc7736635610401fa99e4911155329f537c997b57d218821538f0e6b8b212111"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "json-c"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}", "--with-tls=openssl"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end
