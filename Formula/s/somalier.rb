class Somalier < Formula
  desc "Relatedness, QC and ancestry checks from BAM/CRAM/VCF"
  homepage "https://github.com/brentp/somalier"
  url "https://github.com/brentp/somalier/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "506f540589495cdc933b5c9e014f01b16261a567e003bcce60afbcf8de4519a8"
  license "MIT"
  revision 1
  head "https://github.com/brentp/somalier.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2a052913ff9dd15d787839e4101df2d448bf476e93fdcbfdd7914ade90764d3c"
    sha256 cellar: :any, arm64_tahoe:       "b93a8382e401f62054c7a499e7b5e565a5d393665a1132f05aefbc8aeebd1117"
    sha256 cellar: :any, arm64_sequoia:     "a2a91e38eb270c7918363de2553388cfe1faf77b9855f24a6c2ab52c703cd174"
    sha256 cellar: :any, arm64_linux:       "93bc4ca4122594098e9cf3a0178838bf3063e2780240109e8b56831ca24b2c0e"
    sha256 cellar: :any, x86_64_linux:      "92f506756375ecdbd7f5783ab95ceedce4eca2bade5af9bece07285c6de30ffa"
  end

  depends_on "nim" => :build
  depends_on "htslib"
  depends_on "libdeflate"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"

  on_linux do
    # arraymancer's BLAS/LAPACK backend; macOS uses the Accelerate framework.
    depends_on "openblas"
    depends_on "zlib-ng-compat"
  end

  # Nim library dependencies, resolved offline instead of via `nimble`, from the
  # requirements in `somalier.nimble` and in the `.nimble` files of those deps.
  # Only arraymancer and argparse have an upper bound (set in `somalier.nimble`),
  # so their livecheck reads that file. The other requirements are unbounded or
  # lower bounds only, which `nimble` resolves to the newest tag, so livecheck
  # does the same. duktape (`#dev2`) and zip (`#dev`) are required at a branch
  # and untar has no release tags, so they are pinned to the resolved commit and
  # livecheck tracks the version declared on that branch.
  resource "arraymancer" do
    url "https://github.com/mratsim/Arraymancer/archive/refs/tags/v0.7.32.tar.gz"
    sha256 "9f99fc513042adad078c0c6f8f9abb4d2546db31a4fc73382c25291f4ec422b4"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/somalier/refs/tags/v#{LATEST_VERSION}/somalier.nimble"
      regex(/"arraymancer\s*<=\s*v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "argparse" do
    url "https://github.com/iffy/nim-argparse/archive/refs/tags/v0.10.1.tar.gz"
    sha256 "90dc867253fc6669b4c43c4526c1299fa8ee3e9d728a9cd38ff37d2408a96c23"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/somalier/refs/tags/v#{LATEST_VERSION}/somalier.nimble"
      regex(/"argparse\s*>=\s*v?(\d+(?:\.\d+)+)/i)
    end
  end

  resource "duktape" do
    url "https://github.com/brentp/duktape-nim/archive/d5e98716b8218c44933fe5b4c57f52c69c7a27ba.tar.gz"
    version "0.1.0"
    sha256 "20027fbc09b5490e517da97883a7b9025047f1dc0015150cd0cd082bee3a344d"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/duktape-nim/refs/heads/dev2/duktape.nimble"
      regex(/^version\s*=\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "hile" do
    url "https://github.com/brentp/hileup/archive/refs/tags/v0.1.0.tar.gz"
    sha256 "9b06a91aaf378066a67b5bf01b35d712feb02a5e4ae21f3d2cbe4606720512b7"

    livecheck do
      url :url
    end
  end

  resource "hts" do
    url "https://github.com/brentp/hts-nim/archive/refs/tags/v0.3.31.tar.gz"
    sha256 "e2e8572156cced4557fcb75ecf5a7ee072bcc7abf81066d4b54d5bf674dab3e0"

    livecheck do
      url :url
    end
  end

  resource "lapper" do
    url "https://github.com/brentp/nim-lapper/archive/refs/tags/v0.1.8.tar.gz"
    sha256 "354c06861b8e29063de8b77a6321502f77d97b7205655ccdaa8b58132fc69b27"

    livecheck do
      url :url
    end
  end

  resource "minizip" do
    url "https://github.com/brentp/nim-minizip/archive/refs/tags/v0.0.11.tar.gz"
    sha256 "e8637a2cc69ec153b1bd3264390ba4ecc891f856d3c1d2ee31ccea40bb5d3820"

    livecheck do
      url :url
    end
  end

  resource "nimblas" do
    url "https://github.com/andreaferretti/nimblas/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "3a34f29fa0cb8d275582cd511f52620d414531136a7ef283ad2a60ebd53c5454"

    livecheck do
      url :url
    end
  end

  resource "nimlapack" do
    url "https://github.com/andreaferretti/nimlapack/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "6734a17e85a7d5a2904db5de542914a5806b9ca446687f8195a23ea11e4bbee2"

    livecheck do
      url :url
    end
  end

  resource "pedfile" do
    url "https://github.com/brentp/pedfile/archive/refs/tags/v0.0.4.tar.gz"
    sha256 "65f6c8244b670bc7d6c8e6a94dadbb2f0a4d1e08fcecb439768ea52059971f7a"

    livecheck do
      url :url
    end
  end

  resource "slivar" do
    url "https://github.com/brentp/slivar/archive/refs/tags/v0.3.4.tar.gz"
    sha256 "144475352296b44174f9702c8796c0db16ba78e9125f6cae2b16df0df7156423"

    livecheck do
      url :url
    end
  end

  resource "stb_image" do
    url "https://gitlab.com/define-private-public/stb_image-Nim/-/archive/2.5/stb_image-Nim-2.5.tar.gz"
    sha256 "492da79ed40042c71202bde72c5ff86b06755fa2c992fc99dab86dc1c4ddb76a"

    livecheck do
      url :url
    end
  end

  resource "untar" do
    url "https://github.com/dom96/untar/archive/b49f6ac94974fe11cb3d396a8a9c533824a497a7.tar.gz"
    version "0.1.0"
    sha256 "3e6d5759231643f86cf8deb07993aeb00e55d09f87bd6e1676baaeece657308f"

    livecheck do
      url "https://raw.githubusercontent.com/dom96/untar/refs/heads/master/untar.nimble"
      regex(/^version\s*=\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "zip" do
    url "https://github.com/brentp/zip/archive/5909fc608d8b6a5f85d6add8f30249f694a362d1.tar.gz"
    version "0.2.1"
    sha256 "6cb13037d1a976c0ee6a222fcd82d28637c27431eb90ab5dbc5c2c96c10cac5b"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/zip/refs/heads/dev/zip.nimble"
      regex(/^version\s*=\s*"v?(\d+(?:\.\d+)+)"/i)
    end
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
      "--passL:-L#{formula_opt_lib("xz")} -llzma",
      "--passL:-lz -lbz2 -lcurl",
      "--dynlibOverride:hts",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("htslib"))}",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("libdeflate"))}",
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
    # `--help` prints the version banner to stderr, so capture it.
    assert_match "somalier version: #{version}", shell_output("#{bin}/somalier --help 2>&1")

    # find-sites reads a VCF and writes a candidate sites file: a real end-to-end run
    (testpath/"in.vcf").write <<~EOS
      ##fileformat=VCFv4.2
      ##contig=<ID=chr1,length=100000>
      ##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency">
      #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO
      chr1\t1000\trs1\tA\tG\t100\tPASS\tAF=0.5
      chr1\t2000\trs2\tC\tT\t100\tPASS\tAF=0.4
    EOS
    # find-sites reads the VCF and writes a bgzipped sites file.
    system bin/"somalier", "find-sites", "in.vcf"
    assert_path_exists testpath/"sites.vcf.gz"
  end
end
