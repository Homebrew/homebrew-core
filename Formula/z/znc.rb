class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "https://wiki.znc.in/ZNC"
  url "https://znc.in/releases/znc-1.9.1.tar.gz"
  sha256 "e8a7cf80e19aad510b4e282eaf61b56bc30df88ea2e0f64fadcdd303c4894f3c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://znc.in/releases/"
    regex(/href=.*?znc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "66bd22a960fb7c962c14e05775de0084b15e61cdb3daff6e0965bee1df478020"
    sha256 arm64_sonoma:  "9675fb4efd12afe3eb02badcadb5ba488f94d99ca81dc6e81d97c72b4210aee9"
    sha256 arm64_ventura: "ed309306734a2c19162fd11d39b4934fde7c61842476b12068f40d49e21ff759"
    sha256 sonoma:        "38066e27e527d7450626cd2d8abb259afd01de1f210220aa4e9d96cb5549da6c"
    sha256 ventura:       "2a7cf664302d64bf2a7eb9bdf102371d6a0156f20076d82f8ef269c0a8df59c3"
    sha256 x86_64_linux:  "3930226096cf81a182bb476d5ead701fc3e7581b1e648cf3f8bcc9e24c640719"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c@75"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "zlib"

  def install
    python3 = "python3.13"
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
