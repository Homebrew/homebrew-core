class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  # NOTE: Make sure to update RPATHs if any "@rpath-referenced libraries" show up in `brew linkage`
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2025_03_1.tar.gz"
  sha256 "947e5aa004047fbec4bf4ba93b84a50ca7f68e248a0654080d8ca0cdb06e3534"
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
    sha256                               arm64_sequoia: "31da430cb2a456ebcb019cb543cee63d7a0232967b39b6c9349b4c362ff160c5"
    sha256                               arm64_sonoma:  "1753ccd22f23a8a147e3fcbde494db9c7928b6d10265fba3ab995d4fb06630c3"
    sha256                               arm64_ventura: "6fb21ed2d43af6d41308f256662f913398b7b531018b52e5b5e5bf83a991197a"
    sha256                               sonoma:        "e2b96a28b8556d7049e4872bdc7c5943af61067f219186ceb6537fb9f500ae04"
    sha256                               ventura:       "979c2e3a9e4b3dec317671290900e15b8c53db09b9eba8483f63a1d50ebd64dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7af3e8d1bf553e469ce35fe0f9d14dcebac0817b2b51f738dcc29bf594aa767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c31476e67fd2c0ca2b4a4f1b51c95e1b6d90bddc58a6e3b001bcaaf9c67041e"
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
