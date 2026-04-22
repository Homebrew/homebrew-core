class Wireshark < Formula
  desc "Network analyzer and capture tool - without graphical user interface"
  homepage "https://www.wireshark.org"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/wireshark/wireshark.git", branch: "master"

  stable do
    url "https://www.wireshark.org/download/src/all-versions/wireshark-4.6.4.tar.xz"
    mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-4.6.4.tar.xz"
    sha256 "fbeab3d85c6c8a5763c8d9b7fe20b5c69ca9f9e7f2b824bedc73135bdca332e2"

    # Apply Fedora's backport of Lua 5.5 support. Includes following commits:
    # https://gitlab.com/wireshark/wireshark/-/commit/ec16791d8d68f9045400a0610a5a10b1ea544dfd
    # https://gitlab.com/wireshark/wireshark/-/commit/1bf12a13e71a6ec1a79cfc73767d35e815b839dd
    patch do
      url "https://src.fedoraproject.org/rpms/wireshark/raw/aa822250ea9ebe0b4199522aba92b3c931488a0b/f/wireshark-0010-find-lua-5.5.patch"
      sha256 "48d682f99981bad6fa26cae9f4b1d96246b51d701136ba9d89d82d5ddd91bbdc"
    end
  end

  # Upstream indicates stable releases with an even-numbered minor (see:
  # https://wiki.wireshark.org/Development/ReleaseNumbers).
  livecheck do
    url "https://www.wireshark.org/download.html"
    regex(/href=.*?wireshark[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "fb70cc4a30876469e96717a747f113ea408fe6e3af51584735055646d226fd13"
    sha256                               arm64_sequoia: "6e18b24d8a0333bf7cfd1c92f602ff0d6019580451d1bc7858c8b106f8599550"
    sha256                               arm64_sonoma:  "85ee2997391e87141421c168fa4497388c9889eb8be390cd4a3294a3065a4a96"
    sha256                               sonoma:        "27ac99b2d325d07a4f4324dc50ecb59de4bf3f07423cc76b91f91baa151c7bc6"
    sha256                               arm64_linux:   "ba445c07c071e8f8661506084b2a92df131e29b1a8cb877d69b2f8670714ceb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b488d1d3c7496b88afaef35ba42f43deceae3dbb8a3dee416691fcddd56c6ee"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libnghttp2"
  depends_on "libnghttp3"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "speexdsp"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build
  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "libgpg-error"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with cask: "wireshark-app"

  def install
    lua = Formula["lua"]
    plugindir = lib/"wireshark/plugins/#{version.major}-#{version.minor}"
    args = %W[
      -DENABLE_BROTLI=OFF
      -DENABLE_SNAPPY=OFF
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DBUILD_wireshark=OFF
      -DBUILD_logray=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"wireshark/extcap")}
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: plugindir/"codecs")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "Development"
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew install wireshark-app

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew install --cask wireshark-chmodbpf
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #include <ws_version.h>

      int main() {
        printf("%d.%d.%d", WIRESHARK_VERSION_MAJOR, WIRESHARK_VERSION_MINOR,
               WIRESHARK_VERSION_MICRO);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}/wireshark", "-o", "test"
    output = shell_output("./test")
    assert_equal version.to_s, output
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
