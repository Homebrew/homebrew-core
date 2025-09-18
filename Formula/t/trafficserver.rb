class Trafficserver < Formula
  desc "HTTP/1.1 and HTTP/2 compliant caching proxy server"
  homepage "https://trafficserver.apache.org/"
  url "https://downloads.apache.org/trafficserver/trafficserver-10.1.0.tar.bz2"
  mirror "https://archive.apache.org/dist/trafficserver/trafficserver-10.1.0.tar.bz2"
  sha256 "bccc35bbfc80f215b0858a0a7e531ac990b13a9eb1e3e81a3b15eaa3fde0596e"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "f1f228335aa43ef6fc7ff8e68c2777dc3ff42335cb0b9b71bc74deac28998ab3"
    sha256 arm64_sequoia: "bd0435227b8259ad3ddb4f0e2554fa80313afc5534a216727907e93ed4449154"
    sha256 arm64_sonoma:  "45d46d5d4940acc9f404ca0a096f8b2b35e4b6633ba7dc8d1ac7992775a2ff78"
    sha256 arm64_ventura: "1cf5918b4f826a901f82779b9e260ad303ce9cef5fa9da4b87680681a5fa4b28"
    sha256 sonoma:        "6f468481e98e0f32cd21782569d9cc7db867f5330c55afbb8f8220af749bab60"
    sha256 ventura:       "49c8fba7b87b464e8fa5b22cf02f94c353cdca306b8860249e004e2b801a7216"
    sha256 arm64_linux:   "445d11a0ce8676fe74a1df1be2fa6b1bf9544ab7e7bd69bdfa931acf62424f1c"
    sha256 x86_64_linux:  "701d46ac0f4dfd5ed88a48e5f01bb55f675f9e275a4e692ba7a773e82e0d39f6"
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
