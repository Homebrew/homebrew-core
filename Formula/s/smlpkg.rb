class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "85af735bd031c5e15a2b627ff6f911648ba8d81f709865b032afad26e42cddd8"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64d7a0494c5c2e5cac024a7219c083c8b8808d7a4afe981d798960d2805d2801"
    sha256 cellar: :any,                 arm64_sequoia: "ed01342c1a3716807c933c7720e8189445b2414da715ecaac739e146138622da"
    sha256 cellar: :any,                 arm64_sonoma:  "d09d40f9b6d4baa32c05ad84c20d3087606a740b00a87a2f2416addb1556181e"
    sha256 cellar: :any,                 sonoma:        "6b61b0040f28343604bb21cac27de6c8f59f5181cd99fb0a793a571d6781b58b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aaddfe9d11c8d933bb7229aaed52a878e9c4b1601a2efd1d1ee4170f116c0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6685aa1a52fb4b26af6a7b489f825bffd9bdd2251a8fe71635552d3a86cb346"
  end

  depends_on "mlton" => :build
  depends_on "gmp"

  def install
    ENV["MLCOMP"] = "mlton"
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
