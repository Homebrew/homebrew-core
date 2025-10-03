class Smlpkg < Formula
  desc "Package manager for Standard ML libraries and programs"
  homepage "https://github.com/diku-dk/smlpkg"
  url "https://github.com/diku-dk/smlpkg/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "53440d8b0166dd689330fc686738076225ac883a00b283e65394cf9312575c33"
  license "MIT"
  head "https://github.com/diku-dk/smlpkg.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "28c00c67af3693cac8219c8cbb574b81d24bc772a01861379ad51e8dea23d608"
    sha256 cellar: :any,                 arm64_sequoia: "a6d8ea56df569f46bf0a674cbdd5506fe90fa9a9377d5a2bb626eb51e7c2659d"
    sha256 cellar: :any,                 arm64_sonoma:  "bf39a2cb3d8362fe82da4e15466587cb521403386f0cc5d187d8bf542ab6facc"
    sha256 cellar: :any,                 sonoma:        "bc992113b06930535a168b765c1e9f0274e642d8bc1a886ecebf07ef574a05ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8fda41d263626cf760a549e000900a2b8810667aea5816dc9157ac207406f2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c781ec2d9590a65aaa91ccb66462d4527d5dbf5254ec3aacd939b73e5d322bf7"
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
