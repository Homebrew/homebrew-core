class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.10.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/z/znc/znc_1.10.3.orig.tar.gz"
  sha256 "68f3f6641b480c041010c5596e1234043e05c9137eda06233845017603095f5b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "7d56ba643d97ce111f37285a843e895104e3f420fee43e2e456c2f0d1db76a12"
    sha256 arm64_tahoe:       "7947ed8151d94715a4745285e071ad45d07ac32a3a901fe46a1abee72120db23"
    sha256 arm64_sequoia:     "c552474ddc59e597bca1588744225576c3bd3ec6fb53c4c6f2fcc60cdabad667"
    sha256 arm64_linux:       "1feb09519eb7ad832c682c7b5a818093fac86fcc03836ba96eba19cb54a9b8f0"
    sha256 x86_64_linux:      "ecc44e5e3720123161361c6978f7a28c2b26804ad27b26c82131c2895b12311c"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "cctz"
  depends_on "icu4c@78"
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
