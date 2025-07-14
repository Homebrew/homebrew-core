class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.0.6.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.0.6.tar.bz2"
  sha256 "b2add52a1df9de19b00405abe56c6d78331c6b439cee361d2ada031a602ced46"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "2d6794e5a0ad69e8be2752879fe6422d66c3246d938f07df4e617b8371e21701"
    sha256 arm64_sonoma:  "cdb32bb48265464d8de86b52c487627d28572332c5ee2c6bb9600bd44aa85931"
    sha256 arm64_ventura: "a34b6d5acddd5597ca2f6f803f9a94d34e89868fc50b676d7559d4b3bbe4753c"
    sha256 sonoma:        "aa8174d5eacf7932ab66e5d8dcd85d4114cb6158197388ee3f77515a6bdbace4"
    sha256 ventura:       "db74ef4ab6e12f6306bf5acd81b22703d2dd8fcd1b6393b14ab1a160bb6398ae"
    sha256 arm64_linux:   "be613bb9effed35cf0ac3bf81d016087fe413ca21c1c857770884beec3a2d6a9"
    sha256 x86_64_linux:  "be67bb37b296409d3accb03a7fd388d945ea5867de758b409106f0c25afb0f8b"
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
