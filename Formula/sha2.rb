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
    cellar :any_skip_relocation
    rebuild 4
    sha256 "b7710c8b0af7a9c0c319b2e417a63d59e7978a6a7be560e172719a8e4a9b56dc" => :big_sur
    sha256 "972453a919bb7c951a9e6bb2c8d27d27db09c85ba2f3c649c29e049f19930012" => :arm64_big_sur
    sha256 "dbcf9483f299affb674b45e9a5d6e3dbb13cc5e18d22b7fbdc6a80c22b6e4c9b" => :catalina
    sha256 "cc85a50ddee16d85b3e1412ad8ce420bddc4fb70af97152f3328e208030823a5" => :mojave
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
