class TracyGenomics < Formula
  desc "Basecalling, alignment, assembly and deconvolution of Sanger chromatograms"
  homepage "https://www.gear-genomics.com/docs/tracy/"
  url "https://github.com/gear-genomics/tracy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b4a69e148fed9e69cee251a8c0e1b6964eb1747b6870d207f67d09a8825605b2"
  license "BSD-3-Clause"
  head "https://github.com/gear-genomics/tracy.git", branch: "main"

  bottle do
    rebuild 2
    manifest_sha256 "bbbcdad4ade2098687d503ba428856b667f7aa55dcc9836c86bd5e8aeb76f6a6"
    sha256 cellar: :any, arm64_golden_gate: "7cc470153733a93eedece63262c46032f19e28f5f9fcd95c4a61326762fac475"
    sha256 cellar: :any, arm64_tahoe:       "187a500f7b71709eddb06a5287a6baef46d3192e45d6a3d623a48f3794053024"
    sha256 cellar: :any, arm64_sequoia:     "72006944e5ae05feeb00eab2487316ed0879cc8c94b018c76ace17f2422aca16"
    sha256 cellar: :any, arm64_linux:       "d1ef5e546797f737d3ae40ffc40f67e690c8d176a20d7f18dbee28922ee305ec"
    sha256 cellar: :any, x86_64_linux:      "c9fc878953b5bcef769a8a0edc49d14e38ee769fa91b9e7e5ba7b0bc185004e6"
  end

  depends_on "boost"
  depends_on "htslib"

  conflicts_with "tracy", because: "both install `tracy` binaries"

  # Header-only `sdsl-lite`, pulled in as a git submodule upstream.
  resource "sdsl-lite" do
    url "https://github.com/xxsds/sdsl-lite/archive/refs/tags/v3.0.4.tar.gz"
    sha256 "9bade92986d5b6dae15b723f6b2d87b14842e56295558f88c8daaeb33c46967e"
  end

  def install
    resource("sdsl-lite").stage(buildpath/"sdsl-lite")

    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # strip linkage to indirect deps

    system "make", "src/tracy",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}",
           "SDSL_ROOT=#{buildpath}/sdsl-lite"
    bin.install "src/tracy"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracy --version")

    (testpath/"ref.fa").write ">chr1\n#{"ACGT" * 20}\n"
    system "gzip", testpath/"ref.fa"

    system bin/"tracy", "index", "-o", "ref.fm9", "ref.fa.gz"
    assert_path_exists testpath/"ref.fm9"
  end
end
