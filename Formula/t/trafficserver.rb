class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.1.1.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.1.tar.bz2"
    sha256 "793af06a5e45f1c53245c227a7af17a19a6cf18f04d366866e7ac62c5a28d292"

    depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  end

  # Allow livechecking for new releases while deprecated.
  livecheck do
    url :stable
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "d8e4fa5e13e8822946de2772c88a334b3e7e430fba31e4e3329e6ea3f829c48d"
    sha256 arm64_sequoia: "72b9a62fa880ace2d24edf9be492d43e15000e1c9162fde40ab1c845b2f7067f"
    sha256 arm64_sonoma:  "ede50d93ac297899f385192c8a9df6e557e4e1eca12d4a1c71362981a0a7285f"
    sha256 sonoma:        "226fb5553211df0c672cd07b1e4cfa912343f43b9e02766b3f68814f9f8a9033"
    sha256 arm64_linux:   "8d77b971e1f2845185d98edcc26a28e15cabc9813e121e02b8f4c9c25b80fe15"
    sha256 x86_64_linux:  "d796189230e2f4f0fabe59f16cebad73c323edc25dc9db03c0f5f5ac829b787b"
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
