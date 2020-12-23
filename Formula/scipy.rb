class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/aa/d5/dd06fe0e274e579e1dff21aa021219c039df40e39709fabe559faed072a5/scipy-1.5.4.tar.gz"
  sha256 "4a453d5e5689de62e5d38edf40af3f17560bfd63c9c5bd228c18c1f99afa155b"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "e6ac47d444999cbfdf8c68f4016af207e093fcfa8f60da704e6e1ca1bf8963d2" => :big_sur
    sha256 "459a424a9433cefd235ae700f3016a070df09fadff99246ac72be3427a2259d1" => :catalina
    sha256 "a5955e92c790150cac7c173c73eaa70447762b7afb67c658889ceb2ddcef30ae" => :mojave
    sha256 "b660e024594d7d6c0c7717888b50e4656a74fb04359cbeeb87903ce9d77aae2f" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"

  cxxstdlib_check :skip

  def install
    # Fix for current GCC on Big Sur, which does not like 11 as version value
    # (reported at https://github.com/iains/gcc-darwin-arm64/issues/31#issuecomment-750343944)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "11.0" if MacOS.version == :big_sur

    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

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

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import scipy"
  end
end
