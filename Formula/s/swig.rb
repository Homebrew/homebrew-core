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
    sha256 arm64_tahoe:   "f81744448d2febe7a570d66b5b7369d35cccef3d096edef61701b01926a46680"
    sha256 arm64_sequoia: "dcc28b964c457a9cdf7821589be61ad6634273320bb55ce4649e0baa23593bef"
    sha256 arm64_sonoma:  "343fe4b5de85267a1bdcbb0a9ebab3ba8f8693949368ca2811262ff1f93eb200"
    sha256 tahoe:         "8b6a5fd4c930e215c199e4d839d24dbeeccc9d9c9186df30b1f5f8c828b64110"
    sha256 sonoma:        "198565cf5ba843a3e16194a834eb08e45634138ec387704eec46184ac4a01bc3"
    sha256 arm64_linux:   "32d185b5d3c8cf39d2079d8865b1ee54526cd40b0f41ef815e14c6386522016f"
    sha256 x86_64_linux:  "0fe3e8eccfbd0ad2fa8cbf0cdbe06646fb3fc14946dd6cdc5b7a3a33451f3242"
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
