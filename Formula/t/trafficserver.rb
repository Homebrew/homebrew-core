class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://downloads.apache.org/trafficserver/trafficserver-10.1.1.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.1.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.0.tar.bz2"
    sha256 "793af06a5e45f1c53245c227a7af17a19a6cf18f04d366866e7ac62c5a28d292"

    depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  end

  # Allow livechecking for new releases while deprecated.
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_tahoe:   "6a7d414ba4845e774e6b4d43ef084223bad75e4aaa3221d4ee92598f451da25f"
    sha256 arm64_sequoia: "b040641bc444e293343ad6443a465bbeedf4fd599e3c8c1a72ea219a9593c1cf"
    sha256 arm64_sonoma:  "aae83fa2f246435502f568a269d239c5b4d00abb510db55369eb23650f746138"
    sha256 sonoma:        "8f71dfe1f7fb783d1281c73622c6f1126dac18b4974a401bb6d1dd6d9f4077a1"
    sha256 arm64_linux:   "17e853639cdd0e238e53581df1814a85803c2cbdf1bde81057c6177d7b05c0c9"
    sha256 x86_64_linux:  "880c8a051f548091d4968d6fc583188f96b2c7051047840516c99a865f438c86"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "libcap"
    depends_on "libunwind"
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
