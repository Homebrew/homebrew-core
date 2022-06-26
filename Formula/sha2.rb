class Sha2 < Formula
  desc "Implementation of SHA-256, SHA-384, and SHA-512 hash algorithms"
  homepage "https://aarongifford.com/computers/sha.html"
  url "https://aarongifford.com/computers/sha2-1.0.1.tgz"
  sha256 "67bc662955c6ca2fa6a0ce372c4794ec3d0cd2c1e50b124e7a75af7e23dd1d0c"

  livecheck do
    url :homepage
    regex(/href=.*?sha2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7178bff489d57934b0a2cce761b9712ba24d24bb10e7f117ffa5e9c15b87e6d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "972453a919bb7c951a9e6bb2c8d27d27db09c85ba2f3c649c29e049f19930012"
    sha256 cellar: :any_skip_relocation, monterey:       "3617838db639dd063638f0ad0de96e5ecdd8bfbf087337efb7665cf55913a8e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7710c8b0af7a9c0c319b2e417a63d59e7978a6a7be560e172719a8e4a9b56dc"
    sha256 cellar: :any_skip_relocation, catalina:       "dbcf9483f299affb674b45e9a5d6e3dbb13cc5e18d22b7fbdc6a80c22b6e4c9b"
    sha256 cellar: :any_skip_relocation, mojave:         "cc85a50ddee16d85b3e1412ad8ce420bddc4fb70af97152f3328e208030823a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027526015a81f4aec75269a3c104a0fab290359471f228d87f0922a788eedee0"
  end

  def install
    # Xcode 12 made -Wimplicit-function-declaration an error by default so we need to
    # disable that warning to successfully compile:
    system ENV.cc, "-o", "sha2", "-Wno-implicit-function-declaration", "sha2prog.c", "sha2.c"
    system "perl", "sha2test.pl"
    bin.install "sha2"
  end

  test do
    (testpath/"checkme.txt").write "homebrew"
    output = "12c87370d1b5472793e67682596b60efe2c6038d63d04134a1a88544509737b4"
    assert_match output, pipe_output("#{bin}/sha2 -q -256 #{testpath}/checkme.txt")
  end
end
