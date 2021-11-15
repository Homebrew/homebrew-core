class Tclap < Formula
  desc "Templatized C++ command-line parser library"
  homepage "https://tclap.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tclap/tclap-1.2.5.tar.gz"
  sha256 "bb649f76dae35e8d0dcba4b52acfd4e062d787e6a81b43f7a4b01275153165a6"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/tclap[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "620d1a095cdeedb75d61a783f09edb970e79eb776dc574c67209bb4872127b15"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    # Installer scripts have problems with parallel make
    ENV.deparallelize
    system "make", "install"
  end
end
