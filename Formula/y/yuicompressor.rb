class Yuicompressor < Formula
  desc "Yahoo! JavaScript and CSS compressor"
  homepage "https://yui.github.io/yuicompressor/"
  url "https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.zip"
  sha256 "3243fd79cb68cc61a5278a8ff67a0ad6a2d825c36464594b66900ad8426a6a6e"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8f29cb084549e077a7ba1a0aaa2ad5c78d4067de0d3a019ef8ec831f55a542f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39a0c85d86b163e85204877c02dc2028d458aaa93822a9744bd3ce6cf883163b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a0c85d86b163e85204877c02dc2028d458aaa93822a9744bd3ce6cf883163b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a0c85d86b163e85204877c02dc2028d458aaa93822a9744bd3ce6cf883163b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a777992c7ffb05c413bcc9d2f7e6abafffc51af453be8300eb14944393b73c20"
    sha256 cellar: :any_skip_relocation, ventura:        "a777992c7ffb05c413bcc9d2f7e6abafffc51af453be8300eb14944393b73c20"
    sha256 cellar: :any_skip_relocation, monterey:       "a777992c7ffb05c413bcc9d2f7e6abafffc51af453be8300eb14944393b73c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ecbde7c5fb11f028b5bca5b4174f007370df1827ea1e83a603c89c522823855"
  end

  depends_on "openjdk"

  def install
    libexec.install "yuicompressor-#{version}.jar"
    bin.write_jar_script libexec/"yuicompressor-#{version}.jar", "yuicompressor"
  end

  test do
    path = testpath/"test.js"
    path.write <<~EOS
      var i = 1;      // foo
      console.log(i); // bar
    EOS

    output = `#{bin}/yuicompressor --nomunge --preserve-semi #{path}`.strip
    assert_equal "var i=1;console.log(i);", output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
