class Swig < Formula
  desc "Generate scripting interfaces to C/C++ code"
  homepage "https://www.swig.org/"
  url "https://downloads.sourceforge.net/project/swig/swig/swig-4.5.1/swig-4.5.1.tar.gz"
  sha256 "7fec50b27deddab5455a9633780b6341eddfb96215a7619e93a76eb27178f653"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url "https://sourceforge.net/projects/swig/rss?path=/swig"
    regex(%r{url=.*?/swig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "da75d54cd9ad9ae5c7bfc712734f8a971f61735f030584f34e929462223208c3"
    sha256 arm64_sequoia: "81ecbdfb1e57316004365b47a1c3f3cea100c3ef5f7a9ff0c218b8da73821461"
    sha256 arm64_sonoma:  "aae4b6f5244c4c56ec3972870855203a78bf7719416365c7f487c549e066de00"
    sha256 arm64_linux:   "29bcdf36ce033dcc962832928418a115a1ac7833252b8ae47f41875941a7e0bc"
    sha256 x86_64_linux:  "7d404ec2a625493509c20bfa598c8a7b9bee7c90f99d884822307cae9164f53a"
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
