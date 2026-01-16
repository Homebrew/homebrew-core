class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/refs/tags/1.6.2.tar.gz"
  sha256 "a937ef596ad94d16e7ed2c8553ad7be305798dcdcfd65ae60210b1e54ab51a2f"
  license "MIT"
  head "https://github.com/twogood/unshield.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca7cacd291d91e1efd405c583a994117fff1fc42dc0fc464312f502607d8abb9"
    sha256 cellar: :any,                 arm64_sequoia: "958b5103955b4485df69ee82cfefd26fb6f41da6852b05a10b0fa75ec04ae558"
    sha256 cellar: :any,                 arm64_sonoma:  "397ed621a6603bd58822fe74cd47f32a74396f64daeba951c57ffa3fa699eb80"
    sha256 cellar: :any,                 arm64_ventura: "b7cf5fafee5891f097cba5e79298640a672df925261bb8ecf033d07ccd15df2d"
    sha256 cellar: :any,                 sonoma:        "22fe14bf3e367654c7899946475a7eaf8238e27b59a4b7f9c79b0d2705fdba4e"
    sha256 cellar: :any,                 ventura:       "f853aee13b486fec004917ef8a3d35a5ba21171da6f0b0a1c7b0cd1904ff6cf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b65582b6f445ae0cd30ac4761345fb6fedfbdca7ae043818b649645d85f329f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bed5e7793bcfe46608d32e67dd616e8e3058909abb805d4f2f91fa9b8b7e3518"
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
