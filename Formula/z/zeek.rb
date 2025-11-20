class Zeek < Formula
  desc "Network security monitor"
  homepage "https://zeek.org/"
  url "https://github.com/zeek/zeek/releases/download/v8.0.4/zeek-8.0.4.tar.gz"
  sha256 "b11aa1391e240c6ab49838de949bb8ea44635ee8fb8350db4e100c31e83b6a24"
  license "BSD-3-Clause"
  head "https://github.com/zeek/zeek.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "0bbeb62db74a75e0c2dd456460e33e279b11cd41707349603f1d9d608d0c948b"
    sha256 arm64_sequoia: "6d735456debc4c4a91853bab6d18c106c13ef3b2e52215407c1a54e9f25ea21a"
    sha256 arm64_sonoma:  "6ad759bf68d254bf13b1e75be6b3b363e2de8bdaaf0c24318ac029b163554eaa"
    sha256 sonoma:        "3f882e2d562e267544e91a79b5079dec0d5dd02d36885fb1a0559047abb79b1f"
    sha256 arm64_linux:   "7163af5c9dd3212beed54fb2e3eb239a7dfca0c704660b3785a1033d102cb820"
    sha256 x86_64_linux:  "ec21903838f5493b2758a3d9ab31898b5e3b6c1c16483b28b66e6679ae43df5f"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "swig" => :build
  depends_on "c-ares"
  depends_on "libmaxminddb"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zeromq"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

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
                    "-DCARES_ROOT_DIR=#{Formula["c-ares"].opt_prefix}",
                    "-DCARES_LIBRARIES=#{Formula["c-ares"].opt_lib/shared_library("libcares")}",
                    "-DLibMMDB_LIBRARY=#{Formula["libmaxminddb"].opt_lib/shared_library("libmaxminddb")}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    "-DPYTHON_EXECUTABLE=#{which("python3.14")}",
                    "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                    "-DZEEK_LOCAL_STATE_DIR=#{var}",
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
