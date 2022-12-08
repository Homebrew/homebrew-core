class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/Release_2022_09_3.tar.gz"
  sha256 "188239f741842ce433b371e94cdd9e4d93955b332b9ffd5a70db2884270e261b"
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
    sha256 cellar: :any,                 arm64_ventura:  "fe595a91f568f708b0e3f491e43f7f556db4b0cbf1f49eb3627333898e97cbb1"
    sha256 cellar: :any,                 arm64_monterey: "6a3a6f485cf697870f19d7392e4e30205337f03b41ab6083b08b86ad8259bd95"
    sha256 cellar: :any,                 arm64_big_sur:  "f54fa74ef1660b0b60fce19c91108370c8dc75994a760592a41c46945c25f7c6"
    sha256 cellar: :any,                 ventura:        "e12ff745e71900b10c7505656ef26472954a9ab08cde2d5607f165d4c4233801"
    sha256 cellar: :any,                 monterey:       "7dd66bda55ee12c50add2341ca10bf9aea3adef4eb9a88479a3d8cb01bc08d8f"
    sha256 cellar: :any,                 big_sur:        "febc8f817f9d141551077a12271fdcfdd81199c52093af51e79e7ccdae70a7d6"
    sha256 cellar: :any,                 catalina:       "c2632592ce238f3a273bd42ba2c312d7f77c14f958b4b46607268454f08ab90a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c30c80a0d1c9310c7cc78ea7fcc2ffe4de7cb36276d85ed960ca9661e097b1"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@14"
  depends_on "py3cairo"
  depends_on "python@3.11"

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
  end

  # Get Python location
  def python_executable
    python.opt_libexec/"bin/python"
  end

  def postgresql
    Formula["postgresql@14"]
  end

  def install
    ENV.cxx11
    ENV.libcxx
    ENV.append "CFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"
    ENV.append "CXXFLAGS", "-Wno-parentheses -Wno-logical-op-parentheses -Wno-format"

    py3ver = Language::Python.major_minor_version python_executable
    py3prefix = if OS.mac?
      python.opt_frameworks/"Python.framework/Versions"/py3ver
    else
      python.opt_prefix
    end
    py3include = py3prefix/"include/python#{py3ver}"
    site_packages = Language::Python.site_packages(python_executable)
    numpy_include = Formula["numpy"].opt_prefix/site_packages/"numpy/core/include"

    pg_config = postgresql.opt_bin/"pg_config"
    postgresql_lib = Utils.safe_popen_read(pg_config, "--pkglibdir").chomp
    postgresql_include = Utils.safe_popen_read(pg_config, "--includedir-server").chomp

    # set -DMAEPARSER and COORDGEN_FORCE_BUILD=ON to avoid conflicts with some formulae i.e. open-babel
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{lib}
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
      -DPostgreSQL_LIBRARY=#{postgresql_lib}
      -DPostgreSQL_INCLUDE_DIR=#{postgresql_include}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (prefix/site_packages/"homebrew-rdkit.pth").write libexec/site_packages
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME/.bashrc:
        export RDBASE=#{opt_share}/RDKit
    EOS
  end

  test do
    system python_executable, "-c", "import rdkit"
    (testpath/"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{python_executable} test.py 2>&1")
  end
end
