class RnaStar < Formula
  desc "RNA-seq aligner"
  homepage "https://github.com/alexdobin/STAR"
  url "https://github.com/alexdobin/STAR/archive/refs/tags/2.7.11b.tar.gz"
  version "2.7.11b"
  sha256 "3f65305e4112bd154c7e22b333dcdaafc681f4a895048fa30fa7ae56cac408e7"
  license all_of: ["MIT", "BSD-2-Clause"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce54c8718ce2f01777c22e6f7b6295570c7e4785716bfebb04a9551eb453bdb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df53db303004a937634a3eaa227119f92eac00286bc80df0558dd1db1e5bb314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12dcd41638c9578c39ee0ecb0ec33996ee390690eb95d68b49f56f0f129c608"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eef8d5c492f1e608a796350bd6a1fd0acfd46487c18ce901aeaf7aae8d570607"
    sha256 cellar: :any_skip_relocation, sonoma:        "b53c13aeff5e16110831413444b3bea8e6bdecbf068950a7431d8e8744f8583b"
    sha256 cellar: :any_skip_relocation, ventura:       "bf2216ad5cce311a52543ea4e1921a203ca6c1f03ed99057f977d804ed8326c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e7fc7429c847374ed68269193f64d78c78359d1fd97bab32ab47d1f3f0719c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8766e41ed4f092c6fc9715603a34309012200a8db2cb2cd0bdea1c40534f64d6"
  end

  uses_from_macos "vim" => :build # needed for xxd
  uses_from_macos "zlib"

  on_macos do
    depends_on "libomp"
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
