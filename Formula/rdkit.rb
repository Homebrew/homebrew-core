class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/Release_2021_09_4.tar.gz"
  sha256 "ce192e85bbdc1dcf24d327197229099c8625ee20ef022fcbd980791fdbfc7203"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0643b5ec5228088d9fac1c202f15a188c4fa9f1ac6c197750c732f4c6ae37571"
    sha256 cellar: :any,                 arm64_big_sur:  "8b6dcff4614ab1f8e5edf9e6c28c242897af3a33688dd2e4dff7b03ddfd0a1e1"
    sha256 cellar: :any,                 monterey:       "fdc9dd876718d5009e9ea4aa62d90ca22d6ade4bd631d37b06a1b60a2c005cb7"
    sha256 cellar: :any,                 big_sur:        "6a8cd3a35d9b1e9e5f20a41a6eccf5977defdc2759b9d7a2355ef8c52c756357"
    sha256 cellar: :any,                 catalina:       "8b38b42a626ea841f29ddd1b52cc7c9ec134e8af0230e1b73ce30cd9f43c9e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9011c3ccbc72c16cf39f0dd0e2569a3ef01d2d9a36e56b5d246003e0eeddca63"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql"
  depends_on "py3cairo"
  depends_on "python@3.9"

  # Fix for Comic Neue md5 checksum change, remove with next release
  patch do
    url "https://github.com/rdkit/rdkit/commit/d05501c5db6f30b72b5d751e7100be165549ebdc.patch?full_index=true"
    sha256 "06eb6f9f8479c9cc227948654c42e71892c4ae19878291cf3e108feb7a8edc7d"
  end

  def install
    ENV.cxx11
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    # Get Python location
    python_executable = Formula["python@3.9"].opt_bin/"python3"
    py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py3prefix = if OS.mac?
      Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    else
      Formula["python@3.9"].opt_prefix
    end
    py3include = "#{py3prefix}/include/python#{py3ver}"
    numpy_include = Formula["numpy"].opt_lib/"python#{py3ver}/site-packages/numpy/core/include"

    # set -DMAEPARSER and COORDGEN_FORCE_BUILD=ON to avoid conflicts with some formulae i.e. open-babel
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
      -DRDK_INSTALL_INTREE=OFF
      -DRDK_BUILD_SWIG_WRAPPERS=OFF
      -DRDK_BUILD_AVALON_SUPPORT=ON
      -DRDK_BUILD_PGSQL=ON
      -DRDK_PGSQL_STATIC=ON
      -DMAEPARSER_FORCE_BUILD=ON
      -DCOORDGEN_FORCE_BUILD=ON
      -DRDK_BUILD_INCHI_SUPPORT=ON
      -DRDK_BUILD_CPP_TESTS=OFF
      -DRDK_INSTALL_STATIC_LIBS=OFF
      -DRDK_BUILD_CAIRO_SUPPORT=ON
      -DRDK_BUILD_YAEHMOP_SUPPORT=ON
      -DRDK_BUILD_FREESASA_SUPPORT=ON
      -DBoost_NO_BOOST_CMAKE=ON
      -DPYTHON_INCLUDE_DIR=#{py3include}
      -DPYTHON_EXECUTABLE=#{python_executable}
      -DPYTHON_NUMPY_INCLUDE_PATH=#{numpy_include}
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"

    site_packages = "lib/python#{py3ver}/site-packages"
    (prefix/site_packages/"homebrew-rdkit.pth").write libexec/site_packages
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME/.bashrc:
        export RDBASE=#{HOMEBREW_PREFIX}/share/RDKit
    EOS
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import rdkit"
    (testpath/"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py 2>&1")
  end
end
