class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.2.0/swig-4.2.0.tar.gz"
  sha256 "261ca2d7589e260762817b912c075831572b72ff2717942f75b3e51244829c97"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "97cdabcd467f9741ae172546500737a468445f8b7c1030b6835ff1d630c3270b"
    sha256 arm64_ventura:  "18bffb40f30f478d6bf2e0d1e2963dca3e5d5d7fed0e2c7be10bc17aa63dfafa"
    sha256 arm64_monterey: "af291aaee5dae8b1bf12c390176532a11d00e1238e817e2d52896fed78f5ca4c"
    sha256 sonoma:         "24b7aab0a197c733e238565fb52bb5120d188b9d56351423ca7322e39254d17b"
    sha256 ventura:        "da430be477a081fffeb7b57b40c009e62a94087a3b6ffe771258102032cb2c5e"
    sha256 monterey:       "242977d3fe2ac50c7f0e00ad53d147fd36107a334842023326a5d08eaf926a99"
    sha256 x86_64_linux:   "76566cb1026a82ec4bf61e86b4ab5f6377a3a75cffab9062f0103caa6c105202"
  end

  head do
    url "https://github.com/swig/swig.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pcre2"

  uses_from_macos "python" => :test

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
    system "#{bin}/swig", "-python", "test.i"
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_equal "2", shell_output("python3 ./run.py").strip
  end
end
