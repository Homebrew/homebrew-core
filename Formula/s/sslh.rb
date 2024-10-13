class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v2.1.2.tar.gz"
  sha256 "dce8e1a77f48017b5164486084f000d9f20de2d54d293385aec18d606f9c61d9"
  license all_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://github.com/yrutschle/sslh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c1e48be3c7d5714650e0550bd0ba5cf95d981363fd9c867baad75a1b9dc369bd"
    sha256 cellar: :any,                 arm64_sonoma:   "48021bfa2072f6b756640100af21beeb68f5a6437bdca4242da8281c1782889b"
    sha256 cellar: :any,                 arm64_ventura:  "5791bf236c993f9e09c8cd6233ad61f78109f40bcf5f346c42fb9577a383d4fe"
    sha256 cellar: :any,                 arm64_monterey: "196176f2ab3b01d8644a14e76c2a1e312fef2113c2004742d2000f2146dff5a4"
    sha256 cellar: :any,                 sonoma:         "c5d33746b8f5a26e0676e5a31d9d64541b4aadbe9ad60a45bc564032985ea41d"
    sha256 cellar: :any,                 ventura:        "2aba25d6903363e7091983832caf60154fa48909c6cb5fe98724a08597c508b8"
    sha256 cellar: :any,                 monterey:       "d713acd32e00dc43b72e88c0f21339f3e81807b19a9cc255204731efae28d321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c6bbc4c2a053fc0d010ebf06322f76f23f7b61db6556c5aca729f611a22f032"
  end

  depends_on "libconfig"
  depends_on "libev"
  depends_on "pcre2"

  uses_from_macos "netcat" => :test

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    listen_port = free_port
    target_port = free_port

    fork do
      exec sbin/"sslh", "--http=localhost:#{target_port}", "--listen=localhost:#{listen_port}", "--foreground"
    end

    sleep 1
    system "nc", "-z", "localhost", listen_port
  end
end
