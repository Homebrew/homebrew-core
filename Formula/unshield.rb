class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.4.3.tar.gz"
  sha256 "aa8c978dc0eb1158d266eaddcd1852d6d71620ddfc82807fe4bf2e19022b7bab"
  head "https://github.com/twogood/unshield.git"

  bottle do
    sha256 "8573268732d26e07b72ea5f7fce96a3826be475e91648610a89b5cf2a0a12f98" => :mojave
    sha256 "a5fadd49dbea41adc48b239cae345a7befdc04b897c66edea379b9c737c935c2" => :high_sierra
    sha256 "1bfb2381721e5ce11c80a0b828ccbabd4550f3aee1671d4027fb98c4c2869721" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end
