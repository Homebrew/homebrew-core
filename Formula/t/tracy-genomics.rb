class TracyGenomics < Formula
  desc "Basecalling, alignment, assembly and deconvolution of Sanger chromatograms"
  homepage "https://www.gear-genomics.com/docs/tracy/"
  url "https://github.com/gear-genomics/tracy/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b4a69e148fed9e69cee251a8c0e1b6964eb1747b6870d207f67d09a8825605b2"
  license "BSD-3-Clause"
  head "https://github.com/gear-genomics/tracy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "10879f7048d1bccb685f1568b5a0d26f889910cafba8cf2b9685260bb33ae311"
    sha256 cellar: :any, arm64_sequoia: "8afe0caa96c67c7436c2b2cfc9330a14940cb3f3ed040d942ff2c098879ae36f"
    sha256 cellar: :any, arm64_sonoma:  "112acdea080d28492287493fae0875c886eeee1a9ad661352c52db03f740ec85"
    sha256 cellar: :any, sonoma:        "fdb996e8eefcf1ed0f8ed139f599c6fb201e55712b426a51efb663b6b460888f"
    sha256 cellar: :any, arm64_linux:   "bbe01d4d2320574f9c369d6c2767da469532ee7fc51ec32267125556c1f3706c"
    sha256 cellar: :any, x86_64_linux:  "810c0fc55893f416aca8df62bbe37de39a122551c9225dbda9c8ae3524cc6f6f"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "tracy", because: "both install `tracy` binaries"

  # Header-only `sdsl-lite`, pulled in as a git submodule upstream.
  resource "sdsl-lite" do
    url "https://github.com/xxsds/sdsl-lite/archive/refs/tags/v3.0.4.tar.gz"
    sha256 "9bade92986d5b6dae15b723f6b2d87b14842e56295558f88c8daaeb33c46967e"
  end

  def install
    resource("sdsl-lite").stage(buildpath/"sdsl-lite")

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
