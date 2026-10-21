class Sniffles < Formula
  include Language::Python::Virtualenv

  desc "Structural variant caller for long-read sequencing data"
  homepage "https://github.com/fritzsedlazeck/Sniffles"
  url "https://files.pythonhosted.org/packages/f1/99/e71e60c4fa02a6429c273fa3525793e9714f628348c76857b4a6f686218d/sniffles-2.8.1.tar.gz"
  sha256 "9017d22e77ee0ef796e918ec307b6264a5efe7247d0ee5d50f662acc8af53f5f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3a6c1a70e2868a6abad4b4ef2b60b2a7c4a7e548c89c965519271b5d29ce4b51"
    sha256 cellar: :any, arm64_tahoe:       "8ae934b1011fa9995db5f5c8fd5cacb4db7d116cd421fec74e0e410787949c5c"
    sha256 cellar: :any, arm64_sequoia:     "92abb13a1b4494251fe55560bcbf91e1acf9dcd2d5bba3017c93e2e8099923eb"
    sha256 cellar: :any, arm64_linux:       "6abad35c55e535f52ffb2465ca2076178cad44a320be5a68f2d730f531c16f0d"
    sha256 cellar: :any, x86_64_linux:      "ac3ec06deba12708c1da0b57706f5077a8aad977694866de256773aab67c2985"
  end

  depends_on "pybind11" => :build
  depends_on "samtools" => :test
  depends_on "htslib"
  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "spoa"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: ["numpy"]

  resource "edlib" do
    url "https://files.pythonhosted.org/packages/0c/dd/caa71ef15b46375e01581812e52ec8e3f4da0686f370e8b9179eb5f748fb/edlib-1.3.9.post1.tar.gz"
    sha256 "b0fb6e85882cab02208ccd6daa46f80cb9ff1d05764e91bf22920a01d7a6fbfa"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pysam" do
    url "https://files.pythonhosted.org/packages/01/d0/e9271669f97ce454d1aa97f9ce0d3e84376295f352ad6c5d2c3998e38f66/pysam-0.24.1.tar.gz"
    sha256 "90f612afccdb454d2447ecb5229266c6e7f991093deed4ed0a791db01f7fc994"
  end

  resource "pyspoa" do
    url "https://files.pythonhosted.org/packages/1d/d5/6dcb9ae756ef7ad1debff56fd30af8c4806cd68dd747f7fd51d5bad85fc5/pyspoa-0.3.2.tar.gz"
    sha256 "91523a01e2c579acc9fa0423ff4a96912c57c456c876ac08168bab92befbc781"
  end

  # pip's isolated builds download setuptools and Cython
  allow_network_access! :build

  def install
    # Build `pysam` against the brewed `htslib` instead of the bundled copy
    ENV["HTSLIB_LIBRARY_DIR"] = formula_opt_lib("htslib")
    ENV["HTSLIB_INCLUDE_DIR"] = formula_opt_include("htslib")

    venv = virtualenv_install_with_resources without: "pyspoa"

    # Link `pyspoa` against the brewed `spoa` and `pybind11` so its isolated build does not need CMake
    ENV["libspoa"] = formula_opt_lib("spoa")/shared_library("libspoa")
    resource("pyspoa").stage do
      inreplace "pyproject.toml", '"cmake<4", "pybind11", "setuptools", "wheel", "scikit-build"',
                                  '"setuptools", "wheel"'
      inreplace "setup.py", "'src/include/spoa'", "'#{formula_opt_include("spoa")}/spoa'"
      inreplace "setup.py", ", '-mmacosx-version-min=10.7'", ""
      inreplace "setup.py", "import pybind11\n        return pybind11.get_include(self.user)",
                            "return '#{formula_opt_include("pybind11")}'"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    # Build a random reference and ten long reads (both strands) spanning a 200 bp deletion
    srand 42
    ref = Array.new(3000) { "ACGT"[rand(4)] }.join
    (testpath/"ref.fa").write ">chr1\n#{ref}\n"
    sam = +"@HD\tVN:1.6\tSO:coordinate\n@SQ\tSN:chr1\tLN:3000\n"
    10.times do |i|
      start = 500 + (i * 10)
      seq = ref[start...1400] + ref[1600...2600]
      flag = i.odd? ? 16 : 0
      sam << "read#{i}\t#{flag}\tchr1\t#{start + 1}\t60\t#{1400 - start}M200D1000M\t*\t0\t0\t#{seq}\t*\n"
    end
    (testpath/"reads.sam").write sam
    system "samtools", "view", "-b", "-o", "reads.bam", "reads.sam"
    system "samtools", "index", "reads.bam"

    # Contigs shorter than 1 Mbp are skipped unless requested explicitly
    system bin/"sniffles", "--input", "reads.bam", "--vcf", "out.vcf", "--reference", "ref.fa",
                           "--contig", "chr1", "--threads", "1"
    vcf = (testpath/"out.vcf").read
    assert_match "##source=Sniffles2_#{version}", vcf
    assert_match(/^chr1\t1400\t\S+\t[ACGT]{201}\t[ACGT]\t\d+\tPASS\tPRECISE;SVTYPE=DEL;SVLEN=-200;END=1600;/, vcf)
    assert_match "SUPPORT=10;", vcf
  end
end
