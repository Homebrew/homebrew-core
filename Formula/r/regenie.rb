class Regenie < Formula
  desc "Whole genome regression modelling of large genome-wide association studies"
  homepage "https://rgcgithub.github.io/regenie/"
  url "https://github.com/rgcgithub/regenie/archive/refs/tags/v4.1.3.1.tar.gz"
  sha256 "8dacc5b854f73544de0f53219397be92ae85cc5649dd80b1573df9357c3b8bf5"
  license "MIT"
  head "https://github.com/rgcgithub/regenie.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "13876d8c5fcb0eb688ff8a6f49d15f876c5e8555654bbc5530ceae757d654f65"
    sha256 cellar: :any, arm64_tahoe:       "fd63d66177575c7fdb73945ec9ef1a5682a0351a46e70a04338f2e3e55d8b1a4"
    sha256 cellar: :any, arm64_sequoia:     "c56d6f0f780ebae11db4b612a539d76f7de035c8035f1954dbad67222e9eba20"
    sha256 cellar: :any, arm64_linux:       "c3c4f1567a8f38670cba925360c1983816279401984c962c66a6fe1a00886c27"
    sha256 cellar: :any, x86_64_linux:      "f235c6c0fbd6630aaf2f8d740a498d4676ff6a772d308e499a2708877d2d0314"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc" # for libgfortran

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Git mirror as the Fossil server (code.enkre.net) often answers HTTP 508
  resource "bgen" do
    url "https://github.com/nebfield/bgen-git-mirror/archive/refs/tags/v1.1.7.tar.gz"
    sha256 "69703c3f5d6d8c22bd933d2550caf4496f9c8b9876299b162e0b9a2ab2cfa605"

    livecheck do
      url "https://raw.githubusercontent.com/rgcgithub/regenie/refs/tags/v#{LATEST_VERSION}/Dockerfile"
      regex(%r{bgen/tarball/release/v?(\d+(?:\.\d+)+)}i)
    end
  end

  deny_network_access!

  def install
    bgen = buildpath/"bgen"
    resource("bgen").stage bgen
    # Pin C++11 as BGEN's waf build sets no `-std`: https://enkre.net/cgi-bin/code/bgen/tktview/e6c4a71b37
    inreplace bgen/"wscript", "cfg.env.CXXFLAGS = [ '-Wall'", "cfg.env.CXXFLAGS = [ '-std=c++11', '-Wall'"

    cd bgen do
      system "python3", "./waf", "configure"
      system "python3", "./waf"
    end

    ENV["BGEN_PATH"] = bgen
    ENV["HAS_BOOST_IOSTREAM"] = "1"

    gfortran_lib = formula_opt_lib("gcc")/"gcc/current"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_LIBRARY_PATH=#{gfortran_lib}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    cp pkgshare.glob("example/example.{bed,bim,fam}"), testpath
    cp pkgshare.glob("example/{covariates,phenotype_bin}.txt"), testpath

    system bin/"regenie", "--step", "1", "--bed", "example", "--covarFile", "covariates.txt",
                          "--phenoFile", "phenotype_bin.txt", "--bt", "--bsize", "100",
                          "--lowmem", "--lowmem-prefix", testpath/"tmp", "--out", "fit"

    assert_match "fit_1.loco", (testpath/"fit_pred.list").read
    assert_path_exists testpath/"fit_1.loco"

    system bin/"regenie", "--step", "2", "--bed", "example", "--covarFile", "covariates.txt",
                          "--phenoFile", "phenotype_bin.txt", "--bt", "--bsize", "200",
                          "--firth", "--approx", "--pred", "fit_pred.list", "--out", "assoc"

    results = (testpath/"assoc_Y1.regenie").read
    assert_match "CHROM GENPOS ID ALLELE0 ALLELE1", results
    assert_operator results.lines.count, :>, 10
  end
end
