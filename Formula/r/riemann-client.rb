class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://git.madhouse-project.org/algernon/riemann-c-client"
  url "https://git.madhouse-project.org/algernon/riemann-c-client/archive/riemann-c-client-2.1.1.tar.gz"
  sha256 "097e710096dc2e901ae95108277eff1acb6d0383f04137cdea4ce55257c08e10"
  license "LGPL-3.0-or-later"
  head "https://git.madhouse-project.org/algernon/riemann-c-client.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "802b77fa2f9fc2d22a488497d8909d3f5993fc4ae7fdcf5d14c3eba19a413ed8"
    sha256 cellar: :any,                 arm64_monterey: "fe70ede98148a187c44e099b3bb9f27b3f2d123c7ad73c6af9613f82cfd9a1f9"
    sha256 cellar: :any,                 arm64_big_sur:  "57bb213aa15fb45dccb60a1d1e7fad0bd976296110ab13453f4d8b29b465e0cf"
    sha256 cellar: :any,                 ventura:        "6fac261afb6031324d4bd36cd24b6492f53d83774523a0fb15bbc37d72662c59"
    sha256 cellar: :any,                 monterey:       "cb26c23b696f4d6f5c8e8acde091e3cb979f380d20600ad996748b9ed8aca756"
    sha256 cellar: :any,                 big_sur:        "6f847dd81950e70bfcb857bbcedb74011c333b43e76a406cc3f865ee4c201c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5b81ce54007693a8fd2068d8b4a9388697e3c409af20fa70e038c4ebc71b8ec"
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
