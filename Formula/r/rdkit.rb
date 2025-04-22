class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  # NOTE: Make sure to update RPATHs if any "@rpath-referenced libraries" show up in `brew linkage`
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2025_03_1.tar.gz"
  sha256 "947e5aa004047fbec4bf4ba93b84a50ca7f68e248a0654080d8ca0cdb06e3534"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/rdkit/rdkit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256                               arm64_sequoia: "854798021c519f811713bb4ba3abd4c609741794ff4a84d1db1e56f2180c272d"
    sha256                               arm64_sonoma:  "0393e5527230562e86a99353b6512e8ef988f4f07dfac2242f4eb20c45483370"
    sha256                               arm64_ventura: "5df7c4eed7de4bf7340ef6b67ac9f28faefda38847efaba04cd6c6fa0761a72a"
    sha256 cellar: :any,                 sonoma:        "ad4276bbb4dd4dd19dcfc736f9d7022178cf2e2694225a6cd99dbb78ba8caf83"
    sha256 cellar: :any,                 ventura:       "450c6fabf644dd001bf2ddd97d3dafee1082ee9586d6f5a0f977cb9b09476c6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7cef9eed7c6b13c2ccf60331245ab9968c273ad3be1aea4614e7c575f441852"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b689fe35fd8c36d7cf62d1cc0f8295a8720a1ad05ce5119602571dfc6b5776a"
  end

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@14" => [:build, :test]
  depends_on "postgresql@17" => [:build, :test]
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "cairo"
  depends_on "coordgen"
  depends_on "eigen"
  depends_on "freetype"
  depends_on "inchi"
  depends_on "maeparser"
  depends_on "numpy"
  depends_on "py3cairo"
  depends_on "python@3.13"

  resource "better_enums" do
    url "https://github.com/aantron/better-enums/archive/refs/tags/0.11.3.tar.gz"
    sha256 "1b1597f0aa5452b971a94ab13d8de3b59cce17d9c43c8081aa62f42b3376df96"
  end

  def python3
    "python3.13"
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    (buildpath/"better_enums").install resource("better_enums")

    python_rpath = rpath(source: lib/Language::Python.site_packages(python3))
    python_rpaths = [python_rpath, "#{python_rpath}/..", "#{python_rpath}/../.."]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_MODULE_LINKER_FLAGS=#{python_rpaths.map { |path| "-Wl,-rpath,#{path}" }.join(" ")}
      -DCMAKE_REQUIRE_FIND_PACKAGE_coordgen=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_maeparser=ON
      -DCMAKE_REQUIRE_FIND_PACKAGE_Inchi=ON
      -DFETCHCONTENT_SOURCE_DIR_BETTER_ENUMS=#{buildpath}/better_enums
      -DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi
      -DRDK_INSTALL_INTREE=OFF
      -DRDK_BUILD_SWIG_WRAPPERS=OFF
      -DRDK_BUILD_AVALON_SUPPORT=ON
      -DRDK_PGSQL_STATIC=OFF
      -DRDK_BUILD_INCHI_SUPPORT=ON
      -DRDK_BUILD_CPP_TESTS=OFF
      -DRDK_INSTALL_STATIC_LIBS=OFF
      -DRDK_BUILD_CAIRO_SUPPORT=ON
      -DRDK_BUILD_YAEHMOP_SUPPORT=ON
      -DRDK_BUILD_FREESASA_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which(python3)}
    ]
    if build.bottle? && Hardware::CPU.intel? && (!OS.mac? || !MacOS.version.requires_sse42?)
      args << "-DRDK_OPTIMIZE_POPCNT=OFF"
    end
    system "cmake", "-S", ".", "-B", "build", "-DRDK_BUILD_PGSQL=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "Code/PgSQL/rdkit/CMakeLists.txt" do |s|
      # Prevent trying to install into pg_config-defined dirs
      s.sub! "set(PG_PKGLIBDIR \"${PG_PKGLIBDIR}", "set(PG_PKGLIBDIR \"$ENV{PG_PKGLIBDIR}"
      s.sub! "set(PG_EXTENSIONDIR \"${PG_SHAREDIR}", "set(PG_EXTENSIONDIR \"$ENV{PG_SHAREDIR}"
      # Re-use installed libraries when building modules for other PostgreSQL versions
      s.sub!(/^find_package\(PostgreSQL/, "find_package(Cairo REQUIRED)\nfind_package(rdkit REQUIRED)\n\\0")
      s.sub! 'set(pgRDKitLibs "${pgRDKitLibs}${pgRDKitLib}', 'set(pgRDKitLibs "${pgRDKitLibs}RDKit::${pgRDKitLib}'
      s.sub! ";${INCHI_LIBRARIES};", ";"
      # Add RPATH for PostgreSQL cartridge
      s.sub! '"-Wl,-dead_strip_dylibs ', "\\0-Wl,-rpath,#{loader_path}/.. "
    end
    ENV["DESTDIR"] = "/" # to force creation of non-standard PostgreSQL directories

    postgresqls.each do |postgresql|
      ENV["PG_PKGLIBDIR"] = lib/postgresql.name
      ENV["PG_SHAREDIR"] = share/postgresql.name
      builddir = "build_pg#{postgresql.version.major}"

      system "cmake", "-S", ".", "-B", builddir,
                      "-DRDK_BUILD_PGSQL=ON",
                      "-DPostgreSQL_ROOT=#{postgresql.opt_prefix}",
                      "-DPostgreSQL_ADDITIONAL_VERSIONS=#{postgresql.version.major}",
                      *args, *std_cmake_args
      system "cmake", "--build", "#{builddir}/Code/PgSQL/rdkit"
      system "cmake", "--install", builddir, "--component", "pgsql"
    end
  end

  def caveats
    <<~EOS
      You may need to add RDBASE to your environment variables, e.g.
        #{Utils::Shell.export_value("RDBASE", "#{opt_share}/RDKit")}
    EOS
  end

  test do
    # Test Python module
    (testpath/"test.py").write <<~PYTHON
      from rdkit import Chem
      print(Chem.MolToSmiles(Chem.MolFromSmiles('C1=CC=CN=C1')))
    PYTHON
    assert_equal "c1ccncc1", shell_output("#{python3} test.py 2>&1").chomp

    # Test PostgreSQL extension
    ENV["LC_ALL"] = "C"
    postgresqls.each do |postgresql|
      pg_ctl = postgresql.opt_bin/"pg_ctl"
      psql = postgresql.opt_bin/"psql"
      port = free_port

      datadir = testpath/postgresql.name
      system pg_ctl, "initdb", "-D", datadir
      (datadir/"postgresql.conf").write <<~EOS, mode: "a+"

        port = #{port}
      EOS
      system pg_ctl, "start", "-D", datadir, "-l", testpath/"log-#{postgresql.name}"
      begin
        system psql, "-p", port.to_s, "-c", "CREATE EXTENSION \"rdkit\";", "postgres"
      ensure
        system pg_ctl, "stop", "-D", datadir
      end
    end
  end
end
