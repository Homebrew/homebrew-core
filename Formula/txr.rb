class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-261.tar.bz2"
  sha256 "761ffbcc4162e22d45865e7cbb96ffa5d4b07614f7f8a4c8ae1d937d96942755"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b0fef66e056dc9ba417e3d3bcaed334258d259f4ef556612c3215e47178e021f"
    sha256 cellar: :any, big_sur:       "3a356132f22cbde6cec2a2691e71443d22ae561990bd4e1f8ab65a169a4391cf"
    sha256 cellar: :any, catalina:      "591b9e059f1a671e44959cffdd0eb174af2a8ece44cc4c43ceee38d28230e7b2"
    sha256 cellar: :any, mojave:        "11cefec20392cc1c624c29a0f615a594a452626933810cc6079015449d5786f0"
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
