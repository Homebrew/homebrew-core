class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-249.tar.bz2"
  sha256 "b3f13bdacec70b24bbfae3d731b9986410901c1425f7024a2d8696827e76ae3e"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b0bbab0e3e533111a5947043edda7d2d47b8fbb939e7dcdea93588eeedbaaf50" => :big_sur
    sha256 "42730adc812ea2b1f8f9a6f8b303fccddd2c2df305cb5702a9b0171719ae4a69" => :catalina
    sha256 "f824db34d76affaa8dcbda35e0f4e65ef9e171aea6107532413cb1750ed6130f" => :mojave
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
