class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v8.2.2/zeek-8.2.2.tar.gz"
  sha256 "a3b6d60ef6bec3eb12818fe32caec707f9b6d63053eaeee942e4ec9af64d862c"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "7fb16a75374d6da3411667e22f229c77ad11591a0ec1faef7da085b1cd03e6dc"
    sha256 arm64_sequoia: "56222db303c6779bb90a04ad098057ec05760a58d5e80f3a01b20a8e64269c4e"
    sha256 arm64_sonoma:  "2f2351d94aa134bedcd202382f823cc68911b1f8f0138513f9305458ec863171"
    sha256 sonoma:        "dcad9d7f36ac957f9cbfbd93b47a8ebf76c842a750d1eb6841be770aab9ef92f"
    sha256 arm64_linux:   "64a75d8e56df913863d76d29c1a78c72bb4f522ba49e54de080c99f6b8ce8de0"
    sha256 x86_64_linux:  "2e91ac8ae93e05274108f20071df18529433a5aa0d9f165bafdd96c92d4206c0"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "libuv"
  depends_on "node@24"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove SDK paths from zeek-config. This breaks usage with other SDKs.
    # https://github.com/Homebrew/homebrew-core/pull/74932
    inreplace "cmake_templates/zeek-config.in" do |s|
      s.gsub! "@ZEEK_CONFIG_PCAP_INCLUDE_DIR@", ""
      s.gsub! "@ZEEK_CONFIG_ZLIB_INCLUDE_DIR@", ""
    end

    # Avoid references to the Homebrew shims directory
    inreplace "auxil/spicy/hilti/toolchain/src/config.cc.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    system "cmake", "-S", ".", "-B", "build",
                    "-DBROKER_DISABLE_TESTS=on",
                    "-DINSTALL_AUX_TOOLS=on",
                    "-DINSTALL_ZEEKCTL=on",
                    "-DUSE_GEOIP=on",
                    "-DCARES_ROOT_DIR=#{formula_opt_prefix("c-ares")}",
                    "-DCARES_LIBRARIES=#{formula_opt_lib("c-ares")/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{formula_opt_lib("libmaxminddb")/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@3")}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.14")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
                    "-DDISABLE_JAVASCRIPT=off",
                    "-DNODEJS_ROOT_DIR=#{formula_opt_prefix("node@24")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP packet analyzer", shell_output("#{bin}/zeek --print-plugins")
    system bin/"zeek", "-C", "-r", test_fixtures("test.pcap")
    assert_path_exists testpath/"conn.log"
    refute_empty (testpath/"conn.log").read
    assert_path_exists testpath/"http.log"
    refute_empty (testpath/"http.log").read
    # For bottling MacOS SDK paths must not be part of the public include directories, see zeek/zeek#1468.
    refute_includes shell_output("#{bin}/zeek-config --include_dir").chomp, "MacOSX"
  end
end
