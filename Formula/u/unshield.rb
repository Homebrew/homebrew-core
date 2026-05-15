class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/refs/tags/1.6.2.tar.gz"
  sha256 "a937ef596ad94d16e7ed2c8553ad7be305798dcdcfd65ae60210b1e54ab51a2f"
  license "MIT"
  head "https://github.com/twogood/unshield.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "514e1303fb016b6d992a623aba29ae24ee49afcb23a1ce920b3019be881cc257"
    sha256 cellar: :any,                 arm64_sequoia: "a73e18ad8dc26a08d17407ff380f8ea0916bc82defb10642e2d0c5d762ee2d38"
    sha256 cellar: :any,                 arm64_sonoma:  "c09b334a22d22b168419ce8d4baa9ae20ce43f894ab218e0343c8341b63234e0"
    sha256 cellar: :any,                 sonoma:        "d6cea6a06ee0aaa549a7fd124733839eaeb078df6b5bbf18be9222550aa77a11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88d0b260f43f9d5d0749fb0625244ccf78443f02549cf4c23aab3b9f458639e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1689300dc52442fcba8de2ed3c07c8eeecc2430bf6f95861354e14c5f01ab23c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # cmake check for libiconv will miss the OS library without this hint
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", "-DUSE_OUR_OWN_MD5=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"unshield", "-e", "sjis", "-V"
  end
end
