class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.5.1.tar.gz"
  sha256 "34cd97ff1e6f764436d71676e3d6842dc7bd8e2dd5014068da5c560fe4661f60"
  license "MIT"
  revision 1
  head "https://github.com/twogood/unshield.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4919d2591a3822980fc17ed43ce5550ec7a40aa5f0a3df597222147d4eded84d"
    sha256 cellar: :any,                 arm64_monterey: "1956ca8994e481560c1f7d548d3af0f5ebdf82ff632a6bbd5de320cb87162436"
    sha256 cellar: :any,                 arm64_big_sur:  "3f410a76b57b1cde50eb5f564afec25ebc83a5a07b0251bcdbba468c2d902610"
    sha256 cellar: :any,                 ventura:        "32e84d1e1fd8e1b06dede6e390d72c1335cefefcecf875d2088093ac56f67836"
    sha256 cellar: :any,                 monterey:       "cd329f3c7c6a0eb689adc539072a66228042b126b89e41fd7fc2e2017c302b4b"
    sha256 cellar: :any,                 big_sur:        "bcfab080b4f19f79161072f22eb8dbc16ca0907c65ed497784e156f83c102959"
    sha256 cellar: :any,                 catalina:       "459cca0a961fff42ce428014c5ae250925835a722f2553fc015ae0a52d178c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30ebbc1b331b3eff9f80d5ef689f8934ee3c684f7b1cba914b9c1e45795128d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # cmake check for libiconv will miss the OS library without this hint
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DUSE_OUR_OWN_MD5=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"unshield", "-e", "sjis", "-V"
  end
end
