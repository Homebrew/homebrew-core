class Rdkit < Formula
  desc "Open-source chemoinformatics library"
  homepage "https://rdkit.org/"
  # NOTE: Make sure to update RPATHs if any "@rpath-referenced libraries" show up in `brew linkage`
  url "https://github.com/rdkit/rdkit/archive/refs/tags/Release_2025_09_1.tar.gz"
  sha256 "7fb3510b69af358009e2d0763c1d9665ac34f4c2cd3314cf5210ee3d5a33d501"
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
    sha256                               arm64_tahoe:   "196b3bd7410b0dc65624d6d525cc51ca48c69f961f48c4b5d07c2d4b39729a87"
    sha256                               arm64_sequoia: "fd165ec6200aaa8f8f9989942188fc9f296c3f462e8bdfd47fa002413c17e6a8"
    sha256                               arm64_sonoma:  "709b6b9976a723b632f865c3d8b9798b977de85ab6e311f9b72b237d137fde2b"
    sha256 cellar: :any,                 sonoma:        "cf228316aef4978ed51a650420ace449ddddf11b9606924ab5b47b4492f1582d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442e8e1ab3ca1fbc1b0bd206db18309dbc53f6143ce86ccb11d753dbb2fb9626"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4da31b2d2ad9545c3021cbf4803ed237b9e23ccbf07cd081df32429b34941fa9"
  end

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "postgresql@17" => [:build, :test]
  depends_on "postgresql@18" => [:build, :test]
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
  depends_on "python@3.14"

  resource "better_enums" do
    url "https://github.com/aantron/better-enums/archive/refs/tags/0.11.3.tar.gz"
    sha256 "1b1597f0aa5452b971a94ab13d8de3b59cce17d9c43c8081aa62f42b3376df96"
  end

  def python3
    "python3.14"
  end

  def postgresqls
    deps.filter_map { |f| f.to_formula if f.name.start_with?("postgresql@") }
        .sort_by(&:version)
  end

  def install
    odie "Too many postgresql dependencies!" if postgresqls.count > 2
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
