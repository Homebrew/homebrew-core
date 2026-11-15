class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/z/znc/znc_1.10.3.orig.tar.gz"
  sha256 "68f3f6641b480c041010c5596e1234043e05c9137eda06233845017603095f5b"
  license "Apache-2.0"
  revision 2

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "679a9e32470742f87d57f966750719744043696f200fb53bdde0caba2d2237b5"
    sha256 arm64_tahoe:       "47d26904e4f30b0244626623d2e4913a6b7143c6b232dacebcd4f7591b3aabc8"
    sha256 arm64_sequoia:     "5123fcb3933cd787a570b66c42ec3bed2f14c4cb02784eba5b6005514433a96a"
    sha256 arm64_linux:       "9b6bf71c0003770d62caf97affcf9cba0508eea4ee023a9f95243d8809c449b4"
    sha256 x86_64_linux:      "424535a69668e0741d24b18549ad16774d6214766145382b2f6be75d23126707"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@79"
  depends_on "openssl@4"
  depends_on "python@3.15"

  on_linux do
    depends_on "cyrus-sasl"
    depends_on "zlib-ng-compat"
  end

  # Backport support for OpenSSL 4
  patch do
    url "https://github.com/znc/znc/commit/94bcf919e1163564e637df8d437585bc7b55e7aa.patch?full_index=1"
    sha256 "973548dd60d3cec8f079f4b62dc341e8965c3da08735dc20b6c73d77bedef98b"
    type :backport
    resolves "https://github.com/znc/znc/pull/2024"
  end

  deny_network_access!

  def install
    rm_r(["third_party/cctz", "third_party/googletest"])

    xy = Language::Python.major_minor_version python3

    # Fixes: CMake Error: Problem with archive_write_header(): Can't create 'swigpyrun.h'
    ENV.deparallelize

    args = %W[
      -DWANT_PYTHON=ON
      -DWANT_PYTHON_VERSION=python-#{xy}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims directory
    inreplace lib/"pkgconfig/znc.pc", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  service do
    run [opt_bin/"znc", "--foreground"]
    run_type :interval
    interval 300
    log_path var/"log/znc.log"
    error_log_path var/"log/znc.log"
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert_path_exists testpath/".znc/znc.pem"
  end
end
