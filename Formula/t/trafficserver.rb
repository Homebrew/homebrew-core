class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.1.2.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.2.tar.bz2"
    sha256 "39d4882a00f9b0c31ce9e435a11812f10948fc06fa3c16126221e6cc937a4a2b"

    depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  end

  # Allow livechecking for new releases while deprecated.
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_tahoe:   "182206020fb8c695477d8d9eac13639ef9c57c7a93f47b8d3375e7455afb7233"
    sha256 arm64_sequoia: "be8cc8e7c923c76a39d93bba355e3cc79567a8086141322b01d8dbd8e1a47ec8"
    sha256 arm64_sonoma:  "f4d6f283b58d779341d107cecb7ad108710b079305649c5c71cb6baac7e0f2dc"
    sha256 sonoma:        "76799f443752a33873f1436f6d149b6c5370d3ebf9d9c5764631c8b723ea875c"
    sha256 arm64_linux:   "5895ebc5784cebb124bd0720b846f8b88717c924801c2452c2a5d5ccff0efeb2"
    sha256 x86_64_linux:  "776fec6d372542a73e29590c57546f5343145c0e63c47921fe8eb0ffb9fef61d"
  end

  head do
    url "https://github.com/apache/trafficserver.git", branch: "master"

    depends_on "zstd"
  end

  # Can be undeprecated with 10.2.0 release.
  # Backporting PCRE2 support requires 30+ commits and resolving conflicts, so not worth it.
  deprecate! date: "2026-01-14", because: "needs EOL `pcre`"

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

  uses_from_macos "flex" => :build
  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    odie "Remove `pcre` dependency!" if build.stable? && version >= "10.2.0"

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
