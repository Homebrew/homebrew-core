class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.5.1.tar.gz"
  sha256 "34cd97ff1e6f764436d71676e3d6842dc7bd8e2dd5014068da5c560fe4661f60"
  license "MIT"
  revision 1
  head "https://github.com/twogood/unshield.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d31876e117a774b5864c4a99746941f3a286db8e804583cce894725ea7cca401"
    sha256 cellar: :any,                 arm64_big_sur:  "c434bcdec3786fead44ea89892abf2d168ad4263afe1efeef464256a22cb40bc"
    sha256 cellar: :any,                 monterey:       "f247af7437a0f227999bc4ecf283eb0a35ef41bf4484cdf709fff68d13d1e928"
    sha256 cellar: :any,                 big_sur:        "451015e850a1a38df78d02a5bc317e14d4300135430cac4eb2997c5e907c4700"
    sha256 cellar: :any,                 catalina:       "a5c34c82bd26252c3fe123ce8bac519b527384b0ba8f3efe6cbad8579dad3144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca107c54413b500af8d3f9de6c61335ce69f0eb0a789058dc16dae4ac477b14f"
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
