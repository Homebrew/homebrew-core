class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ee6eaf54730ba8dbb41db83afaf55dd576fb40d5d4d7240e91350b52bde15553"
    sha256 arm64_ventura:  "b2b61efde97fb30819e20401df289b60b0785ebb50d59f6ed55e2d52883855f8"
    sha256 arm64_monterey: "1ec419a63bc8bd6af046d8cab7cbc0faa0fd13385b90dea59c0d359548a41c91"
    sha256 sonoma:         "97d86798faf0e95e85b1a7383c1e0ff4eacbce118af2ad76d6bcf10e1ffab337"
    sha256 ventura:        "82d0ea87748360a70f0be47072f4a080396f8bc1bbce669d13dd68924fcdb40b"
    sha256 monterey:       "21fa98d7aaa364cdc304fd4568897e241ec819441c345a3c1a9081703c722e3d"
    sha256 x86_64_linux:   "f17e3e7b444ff827b864d63389e7e42e1cdbddfdd5faf0c1208d09ef62a86917"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "openssl@3"
  depends_on "python@3.12"

  uses_from_macos "zlib"

  def install
    python3 = "python3.12"
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
    assert_predicate testpath/".znc/znc.pem", :exist?
  end
end
