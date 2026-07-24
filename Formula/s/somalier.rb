class Somalier < Formula
  desc "Relatedness, QC and ancestry checks from BAM/CRAM/VCF"
  homepage "https://github.com/brentp/somalier"
  url "https://github.com/brentp/somalier/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c9f6f543eb56c6804fc065392a380c2f231ad280ca44c6d1b12ce5198c66c451"
  license "MIT"
  head "https://github.com/brentp/somalier.git", branch: "master"

  depends_on "nim" => :build
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "openssl@3"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    # arraymancer's BLAS/LAPACK backend; macOS uses the Accelerate framework.
    depends_on "openblas"
  end

  # Nim library dependencies, resolved offline instead of via `nimble`.
  # Most are pinned to a release tag; duktape, hile, slivar, stb_image, untar and
  # zip have no matching tagged release (somalier requires them at a branch or
  # untagged commit) so they are pinned to the exact resolved commit.
  resource "arraymancer" do
    url "https://github.com/mratsim/Arraymancer/archive/refs/tags/v0.7.32.tar.gz"
    sha256 "9f99fc513042adad078c0c6f8f9abb4d2546db31a4fc73382c25291f4ec422b4"
  end

  resource "argparse" do
    url "https://github.com/iffy/nim-argparse/archive/refs/tags/v0.10.1.tar.gz"
    sha256 "90dc867253fc6669b4c43c4526c1299fa8ee3e9d728a9cd38ff37d2408a96c23"
  end

  resource "duktape" do
    url "https://github.com/brentp/duktape-nim/archive/d5e98716b8218c44933fe5b4c57f52c69c7a27ba.tar.gz"
    version "0.1.0"
    sha256 "20027fbc09b5490e517da97883a7b9025047f1dc0015150cd0cd082bee3a344d"
  end

  resource "hile" do
    url "https://github.com/brentp/hileup/archive/e89e603a16c7280ce566c51adda28cbd7f2c2a31.tar.gz"
    version "0.01"
    sha256 "737099a290accf88bd8a6e270d934cce71085f5ba1119309152ee42b0da00f0e"
  end

  resource "hts" do
    url "https://github.com/brentp/hts-nim/archive/refs/tags/v0.3.31.tar.gz"
    sha256 "e2e8572156cced4557fcb75ecf5a7ee072bcc7abf81066d4b54d5bf674dab3e0"
  end

  resource "lapper" do
    url "https://github.com/brentp/nim-lapper/archive/refs/tags/v0.1.8.tar.gz"
    sha256 "354c06861b8e29063de8b77a6321502f77d97b7205655ccdaa8b58132fc69b27"
  end

  resource "minizip" do
    url "https://github.com/brentp/nim-minizip/archive/refs/tags/v0.0.11.tar.gz"
    sha256 "e8637a2cc69ec153b1bd3264390ba4ecc891f856d3c1d2ee31ccea40bb5d3820"
  end

  resource "nimblas" do
    url "https://github.com/andreaferretti/nimblas/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "3a34f29fa0cb8d275582cd511f52620d414531136a7ef283ad2a60ebd53c5454"
  end

  resource "nimlapack" do
    url "https://github.com/andreaferretti/nimlapack/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "6734a17e85a7d5a2904db5de542914a5806b9ca446687f8195a23ea11e4bbee2"
  end

  resource "pedfile" do
    url "https://github.com/brentp/pedfile/archive/refs/tags/v0.0.4.tar.gz"
    sha256 "65f6c8244b670bc7d6c8e6a94dadbb2f0a4d1e08fcecb439768ea52059971f7a"
  end

  resource "slivar" do
    url "https://github.com/brentp/slivar/archive/a04aa8a39c7f9aa69e5cbac30a19620061635a6f.tar.gz"
    version "0.3.4"
    sha256 "f627269949fd40698378ed32475013382c6f24b8779c85f0e9c0ef161ba65e29"
  end

  resource "stb_image" do
    url "https://gitlab.com/define-private-public/stb_image-Nim/-/archive/ba5f45286bfa9bed93d8d6b941949cd6218ec888/stb_image-Nim-ba5f45286bfa9bed93d8d6b941949cd6218ec888.tar.gz"
    version "2.5"
    sha256 "54d52e7eefd1b092619e2748be019790f3ed15def0dfc4d4d1f8ee1fd853e3e6"
  end

  resource "untar" do
    url "https://github.com/dom96/untar/archive/b49f6ac94974fe11cb3d396a8a9c533824a497a7.tar.gz"
    version "0.1.0"
    sha256 "3e6d5759231643f86cf8deb07993aeb00e55d09f87bd6e1676baaeece657308f"
  end

  resource "zip" do
    url "https://github.com/brentp/zip/archive/5909fc608d8b6a5f85d6add8f30249f694a362d1.tar.gz"
    version "0.2.1"
    sha256 "6cb13037d1a976c0ee6a222fcd82d28637c27431eb90ab5dbc5c2c96c10cac5b"
  end

  def install
    vendor = buildpath/"vendor"
    deps = %w[arraymancer argparse duktape hile hts lapper minizip nimblas
              nimlapack pedfile slivar stb_image untar zip]
    deps.each { |r| resource(r).stage(vendor/r) }

    # Each package exposes its modules either at its root or under `src`;
    # add both (Nim ignores paths that do not exist).
    args = deps.flat_map { |r| ["--path:#{vendor}/#{r}", "--path:#{vendor}/#{r}/src"] }
    args += [
      "--passC:-I#{formula_opt_include("htslib")}",
      "--passL:-L#{formula_opt_lib("htslib")} -lhts",
      "--passL:-L#{formula_opt_lib("libdeflate")} -ldeflate",
      "--passL:-L#{formula_opt_lib("openssl@3")} -lcrypto -lssl",
      "--passL:-L#{formula_opt_lib("xz")} -llzma",
      "--passL:-lz -lbz2 -lcurl",
      "--dynlibOverride:hts",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("htslib"))}",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("libdeflate"))}",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("openssl@3"))}",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("xz"))}",
    ]

    # macOS resolves BLAS/LAPACK through the Accelerate framework, but on Linux
    # arraymancer dynamically loads OpenBLAS at startup, so point it there and
    # embed an rpath so the library is found at runtime.
    if OS.linux?
      args += [
        "-d:blas=openblas",
        "-d:lapack=openblas",
        "--passL:-L#{formula_opt_lib("openblas")} -lopenblas",
        "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("openblas"))}",
      ]
    end

    # Remove the upstream nim.cfg which forces an OpenBLAS backend; on macOS the
    # Accelerate framework is used and dependencies are resolved offline above.
    rm "nim.cfg"
    system "nim", "c", "-d:release", "--opt:speed", "--threads:on", "--mm:refc",
           *args, "-o:#{bin}/somalier", "src/somalier.nim"
  end

  test do
    # `--help` prints the version banner to stderr and can exit non-zero,
    # so capture stderr and ignore the exit status.
    assert_match "somalier version: #{version}", shell_output("#{bin}/somalier --help 2>&1 || true")

    # find-sites reads a VCF and writes a candidate sites file: a real end-to-end run
    (testpath/"in.vcf").write <<~EOS
      ##fileformat=VCFv4.2
      ##contig=<ID=chr1,length=100000>
      ##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
      #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO
      chr1\t1000\trs1\tA\tG\t100\tPASS\tAF=0.5
      chr1\t2000\trs2\tC\tT\t100\tPASS\tAF=0.4
    EOS
    # find-sites reads the VCF and writes a bgzipped sites file; the produced
    # file is the real check (the binary may exit non-zero after doing its work).
    shell_output("#{bin}/somalier find-sites in.vcf 2>&1 || true")
    assert_path_exists testpath/"sites.vcf.gz"
  end
end
