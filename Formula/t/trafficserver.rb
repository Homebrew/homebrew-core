class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.0.5.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.0.5.tar.bz2"
  sha256 "79d4efc02a94b38cf75ad3bfc0652d84155b4cdd5cf2cdcdb53399aa6ab8e397"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "8036860308c3d5a166f8e67334892d79dd185b759a88f0bda448dc55e4d152d9"
    sha256 arm64_sonoma:  "e4b4b50ca4ccd123f27e6b140bc9db7faab0c793f71de15660336a1fc495ada2"
    sha256 arm64_ventura: "947ce75f85a4f4e40da713ca19d9700ea6dff56340433f52dae608a81bb14c1a"
    sha256 sonoma:        "5f8f1e5de63f3a656df0c660d47b5394942ea922e1a47397ab62aff7bcf34bb5"
    sha256 ventura:       "f5d7187b184a23f594b870f252f494fcdad54ec0376244a174d608ac4eb68386"
    sha256 arm64_linux:   "d5686131b0ae392e9b63efd83df2fb98e8214ccb4db7d8d2b2ec899c0708b7f7"
    sha256 x86_64_linux:  "bba4bdd8d52ab6650c7957d16818fc22ad7db80032a6490635b9f2e4892efdc2"
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
