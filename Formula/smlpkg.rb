class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.3.tar.gz"
  sha256 "cfa7eeff951e04df428694fda38917ee2aaaf0532e2d1dbea7ab4c150f4fe2f0"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a586b7393075b749b525aee9aedb42b42e8f961997764000b34cb95b1b3da4e9" => :catalina
    sha256 "e2641ae3cb473051e55ae1163b72018028415195b4971a1254fe7cd1f57efb26" => :mojave
    sha256 "27f4bec44d28a9903d720632f1a2ac71c0091a564a0e26c0e896fac4f2becf22" => :high_sierra
  end

  disable! date: "2020-12-08", because: :unmaintained

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
