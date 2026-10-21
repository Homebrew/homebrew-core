class Rustqc < Formula
  desc "Fast genomics quality control tools for sequencing data"
  homepage "https://seqeralabs.github.io/RustQC/"
  url "https://github.com/seqeralabs/rustqc/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "ae8036a60aeba4b68b335a23ef6f0b7468a24b8c4cc42c0dad74f1c423fb7f89"
  license "GPL-3.0-or-later"
  head "https://github.com/seqeralabs/rustqc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "993c0a29d1c51a2890b8cb0a41221f6b57f90c97349daf7ea61f3bf087be7f2f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b1419ed17b22f68162252b1f4ada6162e2d14d030bc5591abe4d5971be73492"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82cd229a6d4de7d597bbabf4a2e5817f5445649afe72d6b52bd9e5296501a66f"
    sha256 cellar: :any,                 arm64_linux:       "64fe2dd8ab1f91037e2a4735941f81e4d8c0a4edf1137bdd0d718b6652f5b249"
    sha256 cellar: :any,                 x86_64_linux:      "4df4b7cf5df823bec6a8cc94f18e0477dee9c103649fd04e075f659e82b04a43"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for `libclang` used by `bindgen`
  uses_from_macos "xz" => :build
  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    depends_on "fontconfig" # `dlopen`ed by `plotters` to render QC plots
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  # hts-sys 2.2.0 uses bindgen 0.69, which emits broken bindings with libclang 22+:
  # https://github.com/rust-lang/rust-bindgen/issues/3275
  resource "hts-sys" do
    url "https://static.crates.io/crates/hts-sys/hts-sys-2.2.1.crate"
    sha256 "fc7e68eb880b02c80cfb41e8dc7904062a3ea7e27b7c4556e88d648dd2f038da"
  end

  deny_network_access!

  def fetch
    system "cargo", "update", "-p", "hts-sys", "--precise", resource("hts-sys").version.to_s
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBCLANG_PATH"] = formula_opt_lib("llvm") if OS.linux?

    # Use system curl and zlib instead of building bundled curl, OpenSSL, xz and zlib-ng
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
