class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "1a14b5d560d1c931528104d644ae033f4f874a21f67f9e6d04f7173e413561ec"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d73ff5e3c879a3ff5f118c233f6488abaae5f523c45f74c94c94eb01f8b341df"
    sha256 arm64_sonoma:  "2db32cd820e5b790b779cb12c893d97efde8f42cbeb3a0a3ea1ec96107debd2d"
    sha256 arm64_ventura: "b1f497f809e6965a254cbe16e75abc8c0f8bca43e1177d854ed6c5dd39e4cdfd"
    sha256 sonoma:        "c9dbbd2cd9c4c87f79604749e1d7faa339a565ee210aad58f7d0356d7059545c"
    sha256 ventura:       "958e5813ea060cda16dfa0048eb1911f6dae4b82ccf47229136c82570ec145b8"
    sha256 arm64_linux:   "59b0ef5e3b65dc547ff688c2a307349e69d9c1752cc1aa0408be320ebbb238b2"
    sha256 x86_64_linux:  "902f4c1fd7a45e1614e802893d4dea09fe1ecacb68c139eed26daa34731ddb02"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "judy"
  depends_on "libdnet"
  depends_on "libunistring" # for unistr.h

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  def install
    inreplace ["conf/zmap.conf", "src/constants.h", "src/zopt.ggo.in"], "/etc", etc
    inreplace "CMakeLists.txt", "set(ZMAP_VERSION DEVELOPMENT)", "set(ZMAP_VERSION #{version})"
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{sbin}/zmap -p 80 -N 1 8.8.8.8 2>&1", 1)
    assert_match "[INFO] zmap: By default, ZMap will output the unique IP addresses " \
                 "of hosts that respond successfully (e.g., SYN-ACK packet)", output
    # need sudo permission
    assert_match "[FATAL] recv: could not open device", output

    system sbin/"zmap", "--version"
  end
end
