class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.3.1/swig-4.3.1.tar.gz"
  sha256 "44fc829f70f1e17d635a2b4d69acab38896699ecc24aa023e516e0eabbec61b8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "1a45fd47424edbf0a25a81c818695b2669f9a8a842fcdc89bd4ba75f84359ad3"
    sha256 arm64_sonoma:  "05db31cb7bde7343e73091a2e3d8c91ee55041f023967cc0430a48a661085ce1"
    sha256 arm64_ventura: "a875754e52f8ceea57710f4fded57d1ff208f54707a4f7c0f4ebfe7f807b3df7"
    sha256 sonoma:        "707733605cd77b4c73261e45e434ca33a2b9cb3d499904d17fbd3fa570124951"
    sha256 ventura:       "b870cddb5b2fff93b65d2f051db91dc5eefc049b972333af7159bee73aa77c09"
    sha256 arm64_linux:   "8460b88cba0cdbe9a30cb1f243a314c1f789b0ceb3a1fe7aadf93ce644e5e9ff"
    sha256 x86_64_linux:  "cef3ffee024b315520f39c088de7108d586b1d295f4764bdf5ec283d2e5a33da"
  end

  head do
    url "https://github.com/swig/swig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre2"

  uses_from_macos "python" => :test
  uses_from_macos "zlib"

  def install
    ENV.append "CXXFLAGS", "-std=c++11" # Fix `nullptr` support detection.
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      int add(int x, int y) {
        return x + y;
      }
    C
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"pyproject.toml").write <<~TOML
      [project]
      name = "test"
      version = "0.1"

      [tool.setuptools]
      ext-modules = [
        {name = "_test", sources = ["test_wrap.c", "test.c"]}
      ]
    TOML
    (testpath/"run.py").write <<~PYTHON
      import test
      print(test.add(1, 1))
    PYTHON

    ENV.remove_from_cflags(/-march=\S*/)
    system bin/"swig", "-python", "test.i"
    system "python3", "-m", "venv", ".venv"
    system testpath/".venv/bin/pip", "install", *std_pip_args(prefix: false, build_isolation: true), "."
    assert_equal "2", shell_output("#{testpath}/.venv/bin/python3 ./run.py").strip
  end
end
