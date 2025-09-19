class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  # NOTE: Make sure to update RPATHs if any "@rpath-referenced libraries" show up in `brew linkage`
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2025_03_6.tar.gz"
  sha256 "aa719755ed10d4068a2037c113faa73007a71b551caf69b946c49cbafe04dadd"
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
    sha256                               arm64_tahoe:   "d4e79f0f170796ebf0938dc89853fa325fbec56f32aae43ec435b7615d39907d"
    sha256                               arm64_sequoia: "b4b468ff0de2145df08a98183a46ad15ed2f0d761f6614926ee4c3b170bc7a25"
    sha256                               arm64_sonoma:  "4d7d93c11b3bf4e9747db5e3669640646fc01c2e1588f6708d8ffb9c3a804c3e"
    sha256                               arm64_ventura: "9b6964d0fd4b741d9e02ebbc73cae246d80c4b97bc1a4df508743ca1c302a22a"
    sha256 cellar: :any,                 sonoma:        "a010b38b78b965e5a6b455cea035b1c02b55b61c62e0869e9182462b3f4207ce"
    sha256 cellar: :any,                 ventura:       "8d41d6393e396e8b7b8ee70f26bc5b952f7ea4cdbf5751f4e9f561fe4d3ad577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b5e2059c77845b67979e05df2e1ac1fd2916e88cb71a14b42ac16e01cbe5920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53975dce86f4230fa564f0d971067ccad0fc085811b5f84f8085231564205a4a"
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
      -DCMAKE_PREFIX_PATH='#{Formula["maeparser"].opt_lib};#{Formula["coordgen"].opt_lib}'
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
