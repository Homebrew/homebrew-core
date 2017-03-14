class Ttyd < Formula
  desc "Command-line tool for sharing terminal over the web"
  homepage "https://github.com/tsl0922/ttyd"
  url "https://github.com/tsl0922/ttyd/archive/1.3.1.tar.gz"
  sha256 "7133704cab2a5fbc187d96511fad87c00e220ae8ed6cb83220d39205cb928070"
  revision 2
  head "https://github.com/tsl0922/ttyd.git"

  bottle do
    cellar :any
    sha256 "d20e006bb5f3acc061a673e6e0e70c2dd9961910c3e718f2f38da90c7a2fd8e9" => :sierra
    sha256 "dbb15685556ddd6524662f3001fbdd120fe80761afd7c41deb3ef8a99da1151f" => :el_capitan
    sha256 "d3cb4a132b564bb6cc941a96abbe1cc6ed9089beecf435b0bba1a2947945c20f" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "json-c"
  depends_on "libwebsockets"

  def install
    cmake_args = std_cmake_args + ["-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttyd --version")
  end
end
