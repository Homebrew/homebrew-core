class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.3.0/swig-4.3.0.tar.gz"
  sha256 "f7203ef796f61af986c70c05816236cbd0d31b7aa9631e5ab53020ab7804aa9e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "db408b24f15006170ea184c9548d1d489564146daa4da7ced7eb2a7d5102d9eb"
    sha256 arm64_sonoma:  "c7d5496a5d5145d7d1f685a566061f6b6cb8f60c16fb22d50e6d6dbabd5c6e1a"
    sha256 arm64_ventura: "47238f89090c776858220e951ead3c6fff0c200ac1a4a1ccaaa37ea943b2c981"
    sha256 sonoma:        "5cce1106f16209f9b522be787c6bbdacc6e43d461acb041faa73b1ddd79d4474"
    sha256 ventura:       "d5903d5bbe73a1c358c251728806ba25c4e4b337dd253a611519059a1b8a47f9"
    sha256 x86_64_linux:  "fcacf510dcbe25a622bf98ba5b71450723e086ca81a28e2d6ce63e17d775eba2"
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
