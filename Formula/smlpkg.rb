class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.5.tar.gz"
  sha256 "53440d8b0166dd689330fc686738076225ac883a00b283e65394cf9312575c33"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "64911c8474f780f2ca5e40dfa42e0d839b5b406b28f2ba97090d52132d2813de"
    sha256 cellar: :any_skip_relocation, catalina: "a710728bd5d1972eb545792375f286691fe75f7d470f532c33517ccf5d85858c"
    sha256 cellar: :any_skip_relocation, mojave:   "6e7e55cdf218da273d5184d411a7a1491b1e52941859bbf08ab610b470b824c4"
  end

  depends_on "mlkit"

  def install
    system "make", "-C", "src", "smlpkg"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    expected_pkg = <<~EOS
      package github.com/diku-dk/testpkg

      require {
        github.com/diku-dk/sml-random 0.1.0 #8b329d10b0df570da087f9e15f3c829c9a1d74c2
      }
    EOS
    system bin/"smlpkg", "init", "github.com/diku-dk/testpkg"
    system bin/"smlpkg", "add", "github.com/diku-dk/sml-random", "0.1.0"
    assert_equal expected_pkg, (testpath/"sml.pkg").read
  end
end
