class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.2.1/swig-4.2.1.tar.gz"
  sha256 "fa045354e2d048b2cddc69579e4256245d4676894858fcf0bab2290ecf59b7d8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "183268434604fe51bf67ca63c6bb3adb0327b698be2214d1eb43c0d5d2ebb231"
    sha256 arm64_ventura:  "0bc1f80fdf13d7aa62a5940fa739162a00b4ae25d6d978d9f7021d08799a08ef"
    sha256 arm64_monterey: "0db87779d83c4f22f94ded633d6c3cc6edfc90be6a3c0b78899cd97f0519316d"
    sha256 sonoma:         "81c8657b9bc70c7a18615e011fb5a1dfd65a0d8ff34b11993194d0c820c439cb"
    sha256 ventura:        "50ec50d91f2abf91deded716fe9f7b1abe144851b79ec59f2ecd7e9f6004c665"
    sha256 monterey:       "eb3bb9b187414f8e0a095c89373cc85559b9e84cbb8ae77e90fcc0ccdde8ed71"
    sha256 x86_64_linux:   "fc7a4fc21a0adda671084c1d85730a5f94bd1528442e15c6579055a485c80300"
  end

  head do
    url "https://github.com/swig/swig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "python-setuptools" => :test
  depends_on "python@3.12" => :test
  depends_on "pcre2"

  def install
    ENV.append "CXXFLAGS", "-std=c++11" # Fix `nullptr` support detection.
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int x, int y)
      {
        return x + y;
      }
    EOS
    (testpath/"test.i").write <<~EOS
      %module test
      %inline %{
      extern int add(int x, int y);
      %}
    EOS
    (testpath/"setup.py").write <<~EOS
      #!/usr/bin/env python3
      from distutils.core import setup, Extension
      test_module = Extension("_test", sources=["test_wrap.c", "test.c"])
      setup(name="test",
            version="0.1",
            ext_modules=[test_module],
            py_modules=["test"])
    EOS
    (testpath/"run.py").write <<~EOS
      #!/usr/bin/env python3
      import test
      print(test.add(1, 1))
    EOS

    ENV.remove_from_cflags(/-march=\S*/)
    system bin/"swig", "-python", "test.i"
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_equal "2", shell_output("python3 ./run.py").strip
  end
end
