class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-275.tar.bz2"
  sha256 "1e6ca44f2879178f4205ad70ee8fc757a4392ecc75424c5ed0904741d1b1541e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "de673487b885d0f4a24ef20dc795e7106b7684ba57a9b422345e2aa9caee5b71"
    sha256 cellar: :any, arm64_big_sur:  "16b34c6968487323a4c950de84bdd1f1b4d8b3ad75b712ccf0db67fcf1b66c04"
    sha256 cellar: :any, monterey:       "a2471ac22c718361f4aaaee2236e76c955b391ea604b96932ec1b44c728e3d90"
    sha256 cellar: :any, big_sur:        "edb0257f75ab3af01cd7e540a2d8e7248dfac8d4bf84c98d7506e15d6d3b1272"
    sha256 cellar: :any, catalina:       "775d10ec58ae42140e29958373d95894e3ed3cedd4d7dfacabbca16536844315"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
