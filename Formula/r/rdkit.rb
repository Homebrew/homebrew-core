class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2023_09_2.tar.gz"
  sha256 "d6ed9e0cdf231550fa850070be7ea53154d46ec6cf32a9b5fd5fec2d34a60c6b"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb654841723476c33987595f6e6c3c0bd8dcdbfdae8a5e5b48cc5ebf52dfd1e3"
    sha256 cellar: :any,                 arm64_ventura:  "4d093cb4bbb93f693b559f3322fe04d0bee3dd17a4500f3347d8fbe3cb0bb498"
    sha256 cellar: :any,                 arm64_monterey: "f7f2c0d2ce431c4bab1b27cc560974dbe7d0000bda79730bae5a2805fd8ee8bc"
    sha256 cellar: :any,                 sonoma:         "b0d402335613f17aff67b2c3436ab548c762271015850921cc3ad1229481c74b"
    sha256 cellar: :any,                 ventura:        "48c52f05ba1229d3331954f28dd4e45a2f2087f117a623fa98343c554ceeee8f"
    sha256 cellar: :any,                 monterey:       "6ddcae931988924796dd2a55574700e4363c24ad21f0ef2f5ab137984c878c3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86fae6fce135731f7e14162db75c876b3e7d6071c0a39ffa1a887fdfca37cba"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@15"
  depends_on "py3cairo"
  depends_on "python@3.12"

  def python
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^python@\d\.\d+$/) }
  end

  # Get Python location
  def python_executable
    python.opt_libexec/"bin/python"
  end

  def postgresql
    Formula["postgresql@15"]
  end

  def install
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
