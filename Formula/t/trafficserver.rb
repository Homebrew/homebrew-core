class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.0.3.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.0.3.tar.bz2"
  sha256 "ec36c1e587e5e54408e4e2a2ec4943533493a2d1f0f708d15e903f836e30db9a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "45f2da56a034362030749ba740116e7a5705e010703ac0b85dffefdcfb074c49"
    sha256 arm64_sonoma:  "4d45f2555b6cdb78724ca47baf496281ed4a60584c6bf669138b255bfa2837ca"
    sha256 arm64_ventura: "2409ba13e0700ea086ff114226e92e941227b4af1c20ca10d97e1e63d9f1fcf8"
    sha256 sonoma:        "2ae71da942af2ea900d4a7e442e73197d893db3c94ac3c96c3a13ea8203effa6"
    sha256 ventura:       "4fafe711f45484a78723ac0e88fe8ff3773d82bb404e54cc1bf21aa77f541a2d"
    sha256 x86_64_linux:  "9f1bb58be4f4c802c3ae94306379e7d0ecef1edf987403f5e4f55d02879802f1"
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
