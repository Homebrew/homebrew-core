class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.4.tar.gz"
  sha256 "634c5b59dbb1ccbc9d6a5f6de494a257e29a3f59dcb6fc30445ff39b45188574"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebc4db6f0fb2c415687dbbb4658eaf527eb94ceddb6336789dcea04382991a5c"
    sha256 cellar: :any_skip_relocation, big_sur:       "345213efdaff1e9b1ea0af2528fed0699beb7050b34b359df70cdf220c3cb399"
    sha256 cellar: :any_skip_relocation, catalina:      "48653e8b3887fd1046f82516ecc3ed5147eeade6d28bd466c1f5c6b320f9a159"
    sha256 cellar: :any_skip_relocation, mojave:        "b3c06dabecff169974b1cd64550e1351f619ebf0c2a09cb4a21b654b42d55b95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b3b01dac1a444a54a25716375cc2c854862f6444087f07ac0c1a0e9ce153529"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
