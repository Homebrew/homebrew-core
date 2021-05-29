class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/Release_2021_03_2.tar.gz"
  sha256 "9907a745405cc915c65504046e446199f8ad03d870714de57c27d3738f330fe4"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.gsub("_", ".") }.compact
    end
  end

  bottle do
    sha256 arm64_big_sur: "4517bab8a0cbf87d593d4da115beef2f5df826eb5f876f57178099fe6007b8fa"
    sha256 big_sur:       "855d43ea94058f878cdba983391f3344d07223ce24b5400fe811adec6adcf305"
    sha256 catalina:      "f8fc9a8cb5afcf5d891fc4a53da47a3a7cc40351d769ce73e735b02987e722ba"
    sha256 mojave:        "6f7c9125af11fa603668b89ca0594648d75a6b2c50934be6191c203ec18137dc"
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

  def install
    ENV.cxx11
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    # Get Python location
    python_executable = Formula["python@3.9"].opt_bin/"python3"
    py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py3prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    on_linux do
      py3prefix = Formula["python@3.9"].opt_prefix
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
