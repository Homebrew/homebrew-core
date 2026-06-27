class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://github.com/snowballstem/snowball/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d8714aa91ed4333654708472a7a98b529c867a8f99b05c5e66febf4ca72c44c7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5566027ab94581a13285689f1479ce695ec96d4d9c6b9f87eda836247e51c70c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a634241627159542a29285520728bcecf54534fa78c28064b0bf92a03a22555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a255c2862ebcb8262f1cfada3300d38a8fa6c38de660e7a8a7bdb528c425ce3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a014d428f0bb2db2dca1f7252999c35116946c287f6f084bdfb2b958f231a8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3aa3302095e530c8f6f77ff6bd10e45ee9f353fb633aa0696dff27e6267bd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a3d6265d87d44f677aa6ff9474fac9ff2a953f11383b661395c279a4e543fe2"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.txt").write("connection")
    cp pkgshare/"examples/stemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output("./test -i test.txt")
  end
end
