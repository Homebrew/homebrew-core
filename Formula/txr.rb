class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-260.tar.bz2"
  sha256 "2181f3579d3155fbc2cf59af0407ce29b0434c14d8686a2db6a72c01c931ddb8"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9befc557af5215b583ab2e205a764cc9ba83b342a548e2e5247778809a086f57"
    sha256 cellar: :any, big_sur:       "2a5a3252a64c86e54bb2bdf58f7308caab91e2ff5639108c8f129cecb9d0db70"
    sha256 cellar: :any, catalina:      "dcdf89a80c186f04cf11f6d0bf7bd3aa063037b49f1a0244a415807c7337f73b"
    sha256 cellar: :any, mojave:        "fe297d55a8956f64c3ed083bcfb61ee751aa99bcc67df17668fe88687b22a192"
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
