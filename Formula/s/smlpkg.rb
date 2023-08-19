class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/v0.1.5.tar.gz"
  sha256 "53440d8b0166dd689330fc686738076225ac883a00b283e65394cf9312575c33"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura:      "a353c05fc5d0d1abe548aae6a333d6afd9831478324b483a2acfa078ad4b4a39"
    sha256 cellar: :any_skip_relocation, monterey:     "59f20ca9b49cf17bcb6931a23477ae7e62ab547520509a66c1a6385713f925b8"
    sha256 cellar: :any_skip_relocation, big_sur:      "dedbec064bc7c579cac83e901849fddf01fd75ff93fb61f547fea21f166995ea"
    sha256 cellar: :any_skip_relocation, catalina:     "081ba1bc8f93af1f393505ad20d46084498a3a268a9a2f5fcbe0bc274964ba95"
    sha256 cellar: :any_skip_relocation, mojave:       "0f714a205b9b960956fdd6fde1a3185adcd6cb26a28e30b30adb4f49c53ab344"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c34eb8d99928a9143212f3273c3a51ec4d2eab32f11f70f626aec59855f1a6a9"
  end

  depends_on "mlkit" => :build
  depends_on arch: :x86_64 # https://github.com/melsman/mlkit/issues/115

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
