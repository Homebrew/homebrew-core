class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.0.4.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.0.4.tar.bz2"
  sha256 "6a52dd860587564440e9e476eefa33b80f915f49e4e3636610d90cffa0f565b9"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "d67edd42a8f953bf3ad9d96832448acf8f52b6828182b21594eb97bd77ce6a31"
    sha256 arm64_sonoma:  "8490c22e694d53f423219cc7857a41eb8c461265aaba15f1671ba850413af981"
    sha256 arm64_ventura: "32e938ff096a2f21e1a2536e074803de2d24c3adae2491a8d1a3f4c437c0c116"
    sha256 sonoma:        "6fda6ee4e4c9497dc58a7f6f0f172d3c3ee7077c3867b979ced55fb7cc2e40d2"
    sha256 ventura:       "179316fa10b7b84c3f22f6dc492fc63cb1bace967dd286035d809cf4c73939d0"
    sha256 x86_64_linux:  "5559e873406e4237a1f749814d9606f54305742f6360677d759f7d685138467d"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "hwloc"
  depends_on "imagemagick"
  depends_on "libmaxminddb"
  depends_on "luajit"
  depends_on "nuraft"
  depends_on "openssl@3"
  depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXPERIMENTAL_PLUGINS=ON",
                    "-DEXTERNAL_YAML_CPP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var/"log/trafficserver").mkpath
    (var/"trafficserver").mkpath

    config = etc/"trafficserver/records.config"
    return unless File.exist?(config)
    return if File.read(config).include?("proxy.config.admin.user_id STRING #{ENV["USER"]}")

    config.append_lines "CONFIG proxy.config.admin.user_id STRING #{ENV["USER"]}"
  end

  test do
    if OS.mac?
      output = shell_output("#{bin}/trafficserver status")
      assert_match "Apache Traffic Server is not running", output
    else
      output = shell_output("#{bin}/trafficserver status 2>&1", 3)
      assert_match "traffic_server is not running", output
    end
  end
end
