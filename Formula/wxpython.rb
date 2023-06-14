class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/aa/64/d749e767a8ce7bdc3d533334e03bb1106fc4e4803d16f931fada9007ee13/wxPython-4.2.1.tar.gz"
  sha256 "e48de211a6606bf072ec3fa778771d6b746c00b7f4b970eb58728ddf56d13d5c"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ecc9ba51d7c1ecccfa9e95a93e6dd9a1b3ae9389bcfd6c59ea78f64a516e21a2"
    sha256 cellar: :any, arm64_monterey: "c4ec5d486f312f880810185ff172f3cf1ad6e29d3ae134bd35dd49aa435176c3"
    sha256 cellar: :any, arm64_big_sur:  "1efd83b12803dc94280d18db9faf7c7908b923a84443b2369af4661923690d47"
    sha256 cellar: :any, ventura:        "9ead65dce312c062a772fad1589434665706e509b6ffd7aa5f320ec9476483e5"
    sha256 cellar: :any, monterey:       "79304e35ef5f033aa46da09e3f668ce0bb1651f482c6ee853719f34f12dca430"
    sha256 cellar: :any, big_sur:        "50bbd5fb5ebf30a376cd174829ece3d81be8432fc6ae872c4e69d0fbeb0bf1a7"
    sha256               x86_64_linux:   "2b0a727845e44862bd0f74d23e0c1e2e8c91959e32d85aebff3ead82a0a10fb5"
  end

  # FIXME: Build is currently broken with Doxygen 1.9.7+.
  # FIXME: depends_on "doxygen" => :build
  depends_on "bison" => :build # for `doxygen` resource
  depends_on "cmake" => :build # for `doxygen` resource
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "wxwidgets"
  uses_from_macos "flex" => :build, since: :big_sur # for `doxygen` resource

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # Build is broken with Doxygen 1.9.7+.
  # TODO: Try to use Homebrew `doxygen` at next release.
  resource "doxygen" do
    url "https://doxygen.nl/files/doxygen-1.9.6.src.tar.gz"
    mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.9.6/doxygen-1.9.6.src.tar.gz"
    sha256 "297f8ba484265ed3ebd3ff3fe7734eb349a77e4f95c8be52ed9977f51dea49df"
  end

  def python
    "python3.11"
  end

  def install
    odie "Check if `doxygen` resource can be removed!" if build.bottle? && version > "4.2.1"
    # TODO: Try removing the block below at the next release.
    resource("doxygen").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPYTHON_EXECUTABLE=#{which(python)}",
                      *std_cmake_args(install_prefix: buildpath/".brew_home")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV["DOXYGEN"] = buildpath/".brew_home/bin/doxygen" # Formula["doxygen"].opt_bin/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, *Language::Python.setup_install_args(prefix, python),
                   "--skip-build",
                   "--install-platlib=#{prefix/Language::Python.site_packages(python)}"
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
