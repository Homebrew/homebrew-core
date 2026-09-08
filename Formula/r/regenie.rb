class Regenie < Formula
  desc "Whole genome regression modelling of large genome-wide association studies"
  homepage "https://rgcgithub.github.io/regenie/"
  url "https://github.com/rgcgithub/regenie/archive/refs/tags/v4.1.3.tar.gz"
  sha256 "5a8ea6ce8a89693cbd272dd64290d361285e0aa858376d25c29284dc58a57b0d"
  license "MIT"
  head "https://github.com/rgcgithub/regenie.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "gcc" # for libgfortran

  uses_from_macos "zlib"

  # regenie links the BGEN reference implementation statically and expects the
  # library's own build tree, so it is built here rather than taken from a
  # formula. Version pinned by upstream's Dockerfile.
  resource "bgen" do
    url "https://code.enkre.net/bgen/tarball/release/v1.1.7"
    sha256 "6476b077af6c8e98e85fd7e09f58cb3fdf143ff91850c984248fd4dc2d74a8c3"
  end

  def install
    bgen = buildpath/"bgen"
    resource("bgen").stage bgen
    # BGEN's waf build overwrites CXXFLAGS and sets no `-std`, so it inherits the
    # compiler default: the boost 1.55 copy it vendors then fails to compile on
    # older libc++, which leaves <tuple> empty below C++11. Its own Makefile uses
    # C++11, so pin the same standard here. Reported upstream:
    # https://enkre.net/cgi-bin/code/bgen/tktview/e6c4a71b37
    inreplace bgen/"wscript", "cfg.env.CXXFLAGS = [ '-Wall'", "cfg.env.CXXFLAGS = [ '-std=c++11', '-Wall'"

    with_env(CC: nil, CXX: nil) do
      cd bgen do
        system formula_opt_bin("python@3.14")/"python3.14", "./waf", "configure"
        system formula_opt_bin("python@3.14")/"python3.14", "./waf"
      end
    end

    # The helper libraries are cross-compiled for x86_64 on every macOS host,
    # which breaks the final link on arm64. Reported upstream, fix submitted:
    # https://github.com/rgcgithub/regenie/issues/695
    # https://github.com/rgcgithub/regenie/pull/694
    %w[mvtnorm pgenlib qf quadpack].each do |lib|
      inreplace "external_libs/#{lib}/Makefile", " += -arch x86_64", " +="
    end

    # `FC ?= gfortran` never applies, because make defines FC as `f77` itself.
    ENV["FC"] = formula_opt_bin("gcc")/"gfortran"
    ENV["BGEN_PATH"] = bgen
    ENV["HAS_BOOST_IOSTREAM"] = "1"

    gfortran_lib = formula_opt_lib("gcc")/"gcc/current"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_LIBRARY_PATH=#{gfortran_lib}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    cp_r Dir[pkgshare/"example/example.{bed,bim,fam}"], testpath
    cp pkgshare/"example/covariates.txt", testpath
    cp pkgshare/"example/phenotype_bin.txt", testpath

    # Step 1 fits the whole genome regression model and writes per-chromosome
    # leave-one-chromosome-out predictions.
    system bin/"regenie", "--step", "1", "--bed", "example", "--covarFile", "covariates.txt",
           "--phenoFile", "phenotype_bin.txt", "--bt", "--bsize", "100",
           "--lowmem", "--lowmem-prefix", testpath/"tmp", "--out", "fit"

    assert_match "fit_1.loco", (testpath/"fit_pred.list").read
    assert_path_exists testpath/"fit_1.loco"

    # Step 2 tests the variants using those predictions.
    system bin/"regenie", "--step", "2", "--bed", "example", "--covarFile", "covariates.txt",
           "--phenoFile", "phenotype_bin.txt", "--bt", "--bsize", "200", "--firth",
           "--approx", "--pred", "fit_pred.list", "--out", "assoc"

    results = (testpath/"assoc_Y1.regenie").read
    assert_match "CHROM GENPOS ID ALLELE0 ALLELE1", results
    assert_operator results.lines.count, :>, 10
  end
end
