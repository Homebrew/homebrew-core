class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/53/10/776750d57ade26522478a92a2e14035868624a6a62f4157b0cc5abd4a980/scipy-1.5.2.tar.gz"
  sha256 "066c513d90eb3fd7567a9e150828d39111ebd88d3e924cdfc9f8ce19ab6f90c9"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "0d42cbfdf53a94f5f437f20a4d8789d0092ebd45da4cc399f822f78578b5cfcd" => :catalina
    sha256 "32666539824b3b8d23b5357eb8f19b1139c3d4bc16359b805271a3a1ea4f1e36" => :mojave
    sha256 "5890c48fe6a148b3813c3a9a86062cef66ad73fda87381235b092d73f576a3c6" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.8"

  cxxstdlib_check :skip

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import scipy"
  end
end
