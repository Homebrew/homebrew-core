class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-256.tar.bz2"
  sha256 "58e3e19bb7f3f9a440761f046fdacbc4d619b11c494a4ed9f8ad25c7a2974ddc"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "044bb9f4079c75363bd08dc5f2be2bf3d8419a38f113e4a0178aee72bfdf29bb"
    sha256 cellar: :any, big_sur:       "5d4728954cc7d47be9e88402be6976144219cf4b1c8afd4965915fcc6c45e66a"
    sha256 cellar: :any, catalina:      "fd265f6c99c13a363b12f3ca857cdc60ee2c079eca20cb29f62ba9b985db78cd"
    sha256 cellar: :any, mojave:        "5f59d37a3d8797777a90cb821e25b972a11e3ab2b956893fa573d23ba8c9477f"
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
