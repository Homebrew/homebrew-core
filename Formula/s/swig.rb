class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.4.0/swig-4.4.0.tar.gz"
  sha256 "c3f8e5dcd68c18aa19847b33b0a1bb92f07e904c53ae9cf5ae4ff8727a72927e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "3f455d50205a0b5635a06ff3efc5af23e69250260f59bee84f1b891b6935d5ce"
    sha256 arm64_sequoia: "bb8a6f319d6bbcda131cae2335f5be0a5e0f10c6ebaf9ca50155ef331ceee4f8"
    sha256 arm64_sonoma:  "9000a532c302d784094b10a99c2e46d1ed6d573c2a9c2a5d2abcdc8019ed045b"
    sha256 tahoe:         "c3d6f99bc61441b2d874b3bc4d974a0a90676db312aa25df98d901a7f766a021"
    sha256 sonoma:        "18e951b0694676531ff6bee4dd94069b895243294a07c92f12385ed1cf7debd8"
    sha256 arm64_linux:   "be5f1d7766e4d162ca4be8a554b900731bc5c3a563bbfa53f8592fcf00339c96"
    sha256 x86_64_linux:  "4e629b02c9e53aebe297c8ff7d8353dfe2ad4649e54a1488d0ead353854e2c4b"
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
