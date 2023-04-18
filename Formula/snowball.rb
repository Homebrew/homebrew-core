class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://github.com/snowballstem/snowball/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "425cdb5fba13a01db59a1713780f0662e984204f402d3dae1525bda9e6d30f1a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e1cf937fbaa3c25c0d7104b1c7734c0c19261f5b9fe6055a4dcca59dcf20e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6974dd00e92e2e7bfc20b4778846c2ed28006b629405da64075f25a1bb9822ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4dd9009ce77704933f0a5ed20dc6ad94eb234f375ea220c24fe1936ee75afe4"
    sha256 cellar: :any_skip_relocation, ventura:        "1375b053e5d742bb072d6ce041f53fbfc14c2e1cda40fbbc4d29cd91fd0177bc"
    sha256 cellar: :any_skip_relocation, monterey:       "421db9b9e06d84eb71c1bd249892c39f69726a645b08317618747534dab7a5ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ddcd5be49b2ff80a37bfacfc8987b51415cc697e7f44c1ed503a2651c0ffe3"
    sha256 cellar: :any_skip_relocation, catalina:       "2d0eb0914d79c2977dbaf48d7c7103de5f09c8bf12dba872f1687522890681e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85b1d508f2b88dbeaaa20e26861c18694f92a8d307830dbf73db60421de57aa"
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
