class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.5.0/swig-4.5.0.tar.gz"
  sha256 "22ae0e887f8cca8031a325c67d005207653200b40e71edb3f88780e28e47d0ff"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "997a24de0f6b18841b3e43632849804d85364e398b2a0018292821eb805faf88"
    sha256 arm64_sequoia: "230e735b366d40760c5daf3c22794397481257d41705f08e2d730a3ff59ad330"
    sha256 arm64_sonoma:  "76d5024ebd63c59b64b461e7736c38dd8167831d160ee47c4930365ee94afb99"
    sha256 tahoe:         "418da66cf63fea20a6d4ef3d04a42c9e7b00713a57745d76f1ea09ebe6bcaa7f"
    sha256 sequoia:       "a0ff2a63bf01d8920e0c0dd947770122674130c241acb1d2a0495413d7fd4505"
    sha256 sonoma:        "b648a410a752f3147391710903c4102b9ea572fc513722718dd45fda61cccf37"
    sha256 arm64_linux:   "03cd9b33f38bbd97a964d5404b7e035d59c8b704bee0f4011c4fe5b0eb95be4d"
    sha256 x86_64_linux:  "8dceef9b8f64d9a364fb9938f35f568959bb0a84193974d7938fe40cf9cfba01"
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
    # Avoid `std_pip_args`: the macOS system pip is too old for its cooldown flag
    system testpath/".venv/bin/pip", "install", "--verbose", "--no-deps", "."
    assert_equal "2", shell_output("#{testpath}/.venv/bin/python3 ./run.py").strip
  end
end
