class Txt2tags < Formula
  include Language::Python::Virtualenv

  desc "Conversion tool to generating several file formats"
  homepage "https://txt2tags.org/"
  url "https://files.pythonhosted.org/packages/27/17/c9cdebfc86e824e25592a20a8871225dad61b6b6c0101f4a2cb3434890dd/txt2tags-3.9.tar.gz"
  sha256 "7e4244db6a63aaa58fc17fa4cdec62b6fb89cc41d3a00ba4edaffa37f27d6746"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "834f5b3ff1ff7933cd7c9421a31cc2c77ccb354093c9323aca86772ef70bec96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbb22dcc68e0184645065d84171197251a31c5479a6e65725f9aeb7ab02fb82b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73a1318632dd5895e35ee09bd6e2fd11d1982b11d01affce8acb7d409f069a75"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2c99b59a535f8f8aaf130a0a5d0744e903e08f0f1ce2d9bf038386446aa7181"
    sha256 cellar: :any_skip_relocation, ventura:        "7a126fb2632a8bfb9f256b4d2ce7f5ea48d43c5c7afcfafeb7eb420a18faf6b1"
    sha256 cellar: :any_skip_relocation, monterey:       "667c1960e75ecdd6987943d0ed760df1255584d739d70dcaabc3a72c46cea6e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f9061ed2a899e6af3ddbbf20bbac612ebfed7e81023a8fa2724dea339474a0"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.txt").write("\n= Title =")
    system bin/"txt2tags", "-t", "html", "--no-headers", "test.txt"
    assert_match "<h1>Title</h1>", File.read("test.html")
  end
end
