class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2024_03_3.tar.gz"
  sha256 "52f79c6bf1d446cdb5c86a35de655d96bad0c52a5f4ecbe15f08eaf334e6f76a"
  license "BSD-3-Clause"
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e79ba4e88cfd5942515c40393c0c5638572066ab25475b40b71326d9a6e6198"
    sha256 cellar: :any,                 arm64_ventura:  "5a1c37494b6d17371fc1879a40b1a1ec054dadb454400a6a0ca8315d9c4ad50f"
    sha256 cellar: :any,                 arm64_monterey: "865023c3d4b8b3d8d571fb5256bf5b3a1d2b747f9ce257baa092881dcc92c255"
    sha256 cellar: :any,                 sonoma:         "8530dabca86a3dbe76cc66b1a0f23cd45a976510433a11747a37cfbd2c4ecf19"
    sha256 cellar: :any,                 ventura:        "9c8599e1cd3a2bde50afa5d844717682370cc7465ad361ff497e93dbec96429f"
    sha256 cellar: :any,                 monterey:       "9e16a58d635fa35d620d92de43044b2a198cd8b83fc21527a9ae1b40829eeca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9711e228ebaf50b97e507c9959b060e7d57e5d1776ec1624fde2fb9f44f305eb"
  end

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairo"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "numpy"
  depends_on "postgresql@14"
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
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("postgresql@") }
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

    # Prevent trying to install into pg_config-defined dirs
    inreplace "Code/PgSQL/rdkit/CMakeLists.txt" do |s|
      s.gsub! "set(PG_PKGLIBDIR \"${PG_PKGLIBDIR}", "set(PG_PKGLIBDIR \"#{lib/postgresql.name}"
      s.gsub! "set(PG_EXTENSIONDIR \"${PG_SHAREDIR}", "set(PG_EXTENSIONDIR \"#{share/postgresql.name}"
    end
    ENV["DESTDIR"] = "/" # to force creation of non-standard PostgreSQL directories

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
      -DPostgreSQL_CONFIG=#{postgresql.bin}/pg_config
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables.
      For Bash, put something like this in your $HOME/.bashrc:
        export RDBASE=#{opt_share}/RDKit
    EOS
  end

  test do
    # Test Python module
    system python_executable, "-c", "import rdkit"
    (testpath/"test.py").write <<~EOS
      from rdkit import Chem ; print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    EOS
    assert_match "c1ccncc1", shell_output("#{python_executable} test.py 2>&1")

    # Test PostgreSQL extension
    ENV["LC_ALL"] = "C"
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    psql = postgresql.opt_bin/"psql"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"

      port = #{port}
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"
    begin
      system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"rdkit\";", "postgres"
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
