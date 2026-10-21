class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=trafficserver/trafficserver-10.2.1.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.2.1.tar.bz2"
  sha256 "352957dc55cab2dd9accfa6b02f1c827109a6b6bb34607381743dbfb8de3b87f"
  license "Apache-2.0"
  head "https://github.com/apache/trafficserver.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "028a7cfd18d6ee1466275168c6935fa19aa290a84c69f8034137b8e097020f7c"
    sha256 arm64_tahoe:       "3ee57169cd9cafd6a7ac4db32eb66e9cd78117e5034aac65f9040d0e73e79ccf"
    sha256 arm64_sequoia:     "9a91aaa4a0c7a4e842ccc3abcca182c35459ab73efeeb350be8bc181875026fe"
    sha256 arm64_linux:       "c4b9e0827ba8f4d5b42ddc806ef880bcab9c650aeabca90c7183d875fda362e9"
    sha256 x86_64_linux:      "859a06584fdbbdb2b43fcdd9e85d2b64a66dea8bc5df1f3a1513430d25b68434"
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
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "yaml-cpp"
  depends_on "zstd"

  uses_from_macos "flex" => :build
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
