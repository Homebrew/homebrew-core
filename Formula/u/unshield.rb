class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/refs/tags/1.6.2.tar.gz"
  sha256 "a937ef596ad94d16e7ed2c8553ad7be305798dcdcfd65ae60210b1e54ab51a2f"
  license "MIT"
  head "https://github.com/twogood/unshield.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a71745f5ca81751bdc007d2d767fa242595cf190b27bc15e2197184061c574fc"
    sha256 cellar: :any,                 arm64_sequoia: "309409b6e7b1d22e402b027c9dae775b8a7311fec26a1aa8847d5ef155e34cfd"
    sha256 cellar: :any,                 arm64_sonoma:  "4752e1173c153c3f877695afd23b068b335709945ec20ac5b1a9525b1c0208a6"
    sha256 cellar: :any,                 sonoma:        "91f0c94d83e2a9e4ee096fa22a11b64242eeb09dd8e378e57ae8da0cefead494"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c11473c5338c952d85e2596e71c221ea48a837f21a7fd09b5925c6da66eac99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094b707a57cd05087eb1737f692213a5b55eb1937f832e606d2418fddb8e867e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
