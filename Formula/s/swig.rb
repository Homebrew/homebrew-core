class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.4.1/swig-4.4.1.tar.gz"
  sha256 "40162a706c56f7592d08fd52ef5511cb7ac191f3593cf07306a0a554c6281fcf"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "296e06c126d3bc5ce67eae4496e4fb15f53b1147fd727e59744449d118ddf3c4"
    sha256 arm64_sequoia: "3f5f55dfeafa86f7fde759a6ed895c17711f795bc5c5dc653e948b160b39e095"
    sha256 arm64_sonoma:  "3deb29512380d6f2438509ef376b9c6420e0c09929f1ba46c6a6defc80b0c938"
    sha256 tahoe:         "7101266ed6af8753601bfa9e161f69b2293bf21c20d85a0215a33afadc8e2bfd"
    sha256 sequoia:       "4a6c4df0a64de986d68c579f9fffa7b51da50a037370584e0c30575be14d86d1"
    sha256 sonoma:        "b46f000c265b1862456a228ada44689992430d48c7d913ccfbf6d39fdb39452c"
    sha256 arm64_linux:   "da35dceea818eca91178d1d69b9ebf15ba68ac343e47fec99c4a3edf889c023e"
    sha256 x86_64_linux:  "a225dfc60e2cf8404edf0275411d60d831b4fbcc707a5019e9246aef10915d98"
  end

  head do
    url "https://github.com/swig/swig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre2"

  uses_from_macos "python" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
