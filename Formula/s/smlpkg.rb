class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "61940ff900196b440d2b2adbae3b59512336b26d25a5259f7df4c9b521bbf1d3"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8e1cbe7dc248864f639c141cf9282fb3dff7e11bd6add87392d35a1740b6e7a"
    sha256 cellar: :any,                 arm64_sequoia: "b926048ee2af5991852a228b739a8655bfa864ffa8e8fb44e814e8a2da2441cf"
    sha256 cellar: :any,                 arm64_sonoma:  "16a0efb76099909c1715d7c4a74dca229e720337cbe524d834f7ba8a6525d5f6"
    sha256 cellar: :any,                 sonoma:        "10955f7f09837e924c506a0493d6404e9c3ff80de01f6a6f309abbe307d76d86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43bb962689915134d7a9974ff609c680d3eebc8e995920b1219209165890aa5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd22f030851de8fe8ad83f66ec207d9ee4b81c7a37ce400fe1889e9e1287f005"
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
