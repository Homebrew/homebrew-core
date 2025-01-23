class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.0.2.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.0.2.tar.bz2"
  sha256 "21b42ec8bcae0ec22f55688d83e7ca13821b73261ebb25f9d1fdded5e804c657"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "ac295e2be0157ee5c1b85450ec723a6da7f69f5c7733fea17176b09837f7cc80"
    sha256 arm64_sonoma:  "8b94765353338915e12cf310316df54f95a4a24dd281da11e2eb1a5437bd6870"
    sha256 arm64_ventura: "05464a026d9c405703061cf3ac88ad71e97acb6cf6e0a680c78aa9a03789c142"
    sha256 sonoma:        "577215262b7bd8094314d2a521e8b4c0fcb72d2978a3741fc919ec659ed2d8a8"
    sha256 ventura:       "07737dd01472d55d6b590c1a4eb19d7c91a92f054c11305a62d6323277ec5e48"
    sha256 x86_64_linux:  "56795be7b8ba2852b92de0f92df9489a5eb2700ba9bc06f1683330e7b826995c"
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
