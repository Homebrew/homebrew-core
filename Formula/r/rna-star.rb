class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.11b.tar.gz"
  version "2.7.11b"
  sha256 "3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7"
  license all_of: ["MIT", "BSD-2-Clause"]

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc36219b20aabc038935df3d795f5ab8046d67f88ad40bf1e90b74f10746621"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab4489cd7b4f3d2272e70a64f88240cfa7f9502d96b483459c97900ff61f9f6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac0c9e88bb13017f4343db7543406c58c1d3da4f836b21b14a80733dd7aa6f84"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d1554593695865e8b97479da30e9e85969a09e3bfed7b85cd76a5fc0f92267c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a0d46c0e0cef0f5dd6eae84587faad3262e7d47bee63308663ec248b8295d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "892ea43a227bf609b9d4f82f2c25b5a7a2ced59672133d48fbee2dd29095705f"
  end

  uses_from_macos "vim" => :build # needed for xxd

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["CXXFLAGS_SIMD="]
    args << "CXXFLAGSextra=-D'COMPILE_FOR_MAC'" if OS.mac?

    cd "source" do
      system "make", "STAR", *args
      bin.install "STAR"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    out = shell_output("#{bin}/STAR --runMode genomeGenerate --genomeFastaFiles test.fasta --genomeSAindexNbases 2")
    assert_match "finished successfully", out
  end
end
