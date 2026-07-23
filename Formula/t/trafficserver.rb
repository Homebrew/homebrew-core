class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  license "Apache-2.0"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.1.3.tar.bz2"
    mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.3.tar.bz2"
    sha256 "b92302005fbd79c3918b97c8546471b988ce0a11dc99a2d39ba092bec45d843a"

    depends_on "pcre" # PCRE2 issue: https://github.com/apache/trafficserver/issues/8780
  end

  # Allow livechecking for new releases while deprecated.
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_tahoe:   "6302e86719bcf7dddb280c8597ffd0f3c0914950ee594d58bb5307cf36362182"
    sha256 arm64_sequoia: "36af3eecc4097491aee6956db810f8203bb919b175f1d19bec87c4cce0851881"
    sha256 arm64_sonoma:  "3ee886b196d9215edbd82b461ded66deebd6bd20937f3dd93e72df32202d3ef5"
    sha256 sonoma:        "0460a4dbabbdfaf22c312b099499cb01a8653d52586f502c214f134ccebfbe62"
    sha256 arm64_linux:   "731b251177e266c41102b94d2d8928a8ff951604e8f6bced3c5955c360bcea42"
    sha256 x86_64_linux:  "79ede126cfbb3e751654376a32402cd2eb104fcf8fd7fc396688979a25fa26c7"
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
