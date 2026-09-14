class Rustqc < Formula
  desc "Fast genomics quality control tools for sequencing data"
  homepage "https://seqeralabs.github.io/RustQC/"
  url "https://github.com/seqeralabs/rustqc/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ae8036a60aeba4b68b335a23ef6f0b7468a24b8c4cc42c0dad74f1c423fb7f89"
  license "GPL-3.0-or-later"
  head "https://github.com/seqeralabs/rustqc.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for `libclang`
  uses_from_macos "xz" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    # `plotters` enables its `fontconfig-dlopen` feature, so `libfontconfig`
    # is loaded with `dlopen` when the QC plots are rendered.
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  # hts-sys 2.2.0 pins bindgen 0.69, which generates incomplete bindings
  # against Clang 22 headers: https://github.com/rust-lang/rust-bindgen/issues/3275
  # hts-sys 2.2.1 uses the fixed bindgen 0.72.1.
  resource "hts-sys" do
    url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.1.crate"
    sha256 "fc7e68eb880b02c80cfb41e8dc7904062a3ea7e27b7c4556e88d648dd2f038da"
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    system "cargo", "update", "-p", "hts-sys", "--precise", "2.2.1"

    # Avoid building bundled curl, OpenSSL, xz and zlib-ng in `hts-sys`.
    resource("hts-sys").stage(buildpath/"hts-sys")
    inreplace "hts-sys/Cargo.toml" do |s|
      s.gsub!(/^features = \[\n\s*"static-curl",\n\s*"static-ssl",/, "features = [")
      s.gsub!(/^features = \["static"\]$/, "")
      s.gsub!(/^features = \[\n\s*"zlib-ng",\n\s*"static",\n\]$/, "")
    end

    system "cargo", "install", "--config", 'patch.crates-io.hts-sys.path="hts-sys"', *std_cargo_args
  end

  test do
    (testpath/"reads.sam").write <<~SAM
      @HD\tVN:1.6\tSO:coordinate
      @SQ\tSN:chr1\tLN:2000
      r1\t0\tchr1\t100\t60\t50M\t*\t0\t0\t#{"ACGT" * 12}AC\t#{"I" * 50}
      r2\t0\tchr1\t120\t60\t50M\t*\t0\t0\t#{"ACGT" * 12}AC\t#{"I" * 50}
      r3\t1024\tchr1\t120\t60\t50M\t*\t0\t0\t#{"ACGT" * 12}AC\t#{"I" * 50}
    SAM
    (testpath/"genes.gtf").write <<~GTF
      chr1\ttest\texon\t50\t500\t.\t+\t.\tgene_id "g1"; transcript_id "t1";
    GTF

    system bin/"rustqc", "rna", "--gtf", "genes.gtf", "reads.sam", "-o", "qc"

    # All three reads overlap the single annotated gene.
    counts = (testpath/"qc/featurecounts/reads.featureCounts.tsv").read
    assert_match(/^g1\tchr1\t50\t500\t\+\t451\t3$/, counts)

    assert_match "3 + 0 in total", (testpath/"qc/samtools/reads.flagstat").read
  end
end
