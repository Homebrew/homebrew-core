class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.2.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.2.0.tar.bz2"
  sha256 "bef171a7d064794e05ec7559e46d3e07c3ae6487a4647987fcc4f1cc5a82cec6"
  license "Apache-2.0"
  head "https://github.com/apache/trafficserver.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "222cef46458d0e878da6222aafe39c7a4881dd00809bc942b54f3953ae43591b"
    sha256 arm64_sequoia: "9d413646a83fccdaec1430ca3dcc5e16e38c3a4c0eba847a6c67660bc9a3250b"
    sha256 arm64_sonoma:  "b7a45470f429ff9e5f3db378ace87015f5e52bbedc58aaf80ec254898735a4b5"
    sha256 sonoma:        "71ea596e4bf516b17c5973924946a90036aacabf44aba60eda48400ccf784d1e"
    sha256 arm64_linux:   "79362c1a8db814b1abc10b05dbcb64bb2c4601a68f99a028eadc1699f269a65c"
    sha256 x86_64_linux:  "970571f59da125b11c8f0d3cb694e5f8140faa1fb666ecd1112d5341168f8d34"
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
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXPERIMENTAL_PLUGINS=ON",
                    "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}",
                    "-DCMAKE_INSTALL_RUNSTATEDIR=#{var}/run/trafficserver",
                    "-DEXTERNAL_YAML_CPP=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMAKE_INSTALL_SYSCONFDIR doesn't work as install_configs.cmake prepends the prefix
    configs = (prefix/"etc/trafficserver").children.select(&:file?)
    pkgetc.install configs
    (prefix/"etc/trafficserver").install_symlink configs.map { |config| pkgetc/config.basename }

    (var/"log/trafficserver").mkpath
    (var/"run/trafficserver").mkpath
    (var/"trafficserver").mkpath
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
