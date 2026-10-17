class Slivar < Formula
  desc "Filter and annotate genetic variants with expressions, for trios and cohorts"
  homepage "https://github.com/brentp/slivar"
  url "https://github.com/brentp/slivar/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "144475352296b44174f9702c8796c0db16ba78e9125f6cae2b16df0df7156423"
  license "MIT"
  head "https://github.com/brentp/slivar.git", branch: "master"

  depends_on "nim" => :build
  depends_on "htslib"

  # Nim library dependencies at the exact versions in upstream's `nimble.lock`,
  # resolved offline instead of via `nimble`; livecheck reads the same file.
  # duktape is locked to a commit on its `dev2` branch, which has no tag.
  resource "argparse" do
    url "https://github.com/iffy/nim-argparse/archive/refs/tags/v0.10.1.tar.gz"
    sha256 "90dc867253fc6669b4c43c4526c1299fa8ee3e9d728a9cd38ff37d2408a96c23"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"argparse":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "duktape" do
    url "https://github.com/brentp/duktape-nim/archive/d5e98716b8218c44933fe5b4c57f52c69c7a27ba.tar.gz"
    version "0.1.0"
    sha256 "20027fbc09b5490e517da97883a7b9025047f1dc0015150cd0cd082bee3a344d"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"duktape":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "hts" do
    url "https://github.com/brentp/hts-nim/archive/refs/tags/v0.3.31.tar.gz"
    sha256 "e2e8572156cced4557fcb75ecf5a7ee072bcc7abf81066d4b54d5bf674dab3e0"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"hts":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "lapper" do
    url "https://github.com/brentp/nim-lapper/archive/refs/tags/v0.1.8.tar.gz"
    sha256 "354c06861b8e29063de8b77a6321502f77d97b7205655ccdaa8b58132fc69b27"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"lapper":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "minizip" do
    url "https://github.com/brentp/nim-minizip/archive/refs/tags/v0.0.11.tar.gz"
    sha256 "e8637a2cc69ec153b1bd3264390ba4ecc891f856d3c1d2ee31ccea40bb5d3820"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"minizip":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  resource "pedfile" do
    url "https://github.com/brentp/pedfile/archive/refs/tags/v0.0.4.tar.gz"
    sha256 "65f6c8244b670bc7d6c8e6a94dadbb2f0a4d1e08fcecb439768ea52059971f7a"

    livecheck do
      url "https://raw.githubusercontent.com/brentp/slivar/refs/tags/v#{LATEST_VERSION}/nimble.lock"
      regex(/"pedfile":\s*\{\s*"version":\s*"v?(\d+(?:\.\d+)+)"/i)
    end
  end

  deny_network_access!

  def install
    vendor = buildpath/"vendor"
    deps = %w[argparse duktape hts lapper minizip pedfile]
    deps.each { |r| resource(r).stage(vendor/r) }

    # Each package exposes its modules either at its root or under `src`;
    # add both (Nim ignores paths that do not exist).
    args = deps.flat_map { |r| ["--path:#{vendor}/#{r}", "--path:#{vendor}/#{r}/src"] }
    args += [
      "--passC:-I#{formula_opt_include("htslib")}",
      "--passL:-L#{formula_opt_lib("htslib")} -lhts",
      "--passL:-Wl,-rpath,#{rpath(target: formula_opt_lib("htslib"))}",
      "--dynlibOverride:hts",
    ]

    # The upstream nim.cfg links statically (`-static`), which macOS does not support.
    rm "nim.cfg"
    system "nim", "c", "-d:release", "--opt:speed", "--threads:on", "--mm:refc",
           "-d:noUndefinedBitOpts", "-d:nimNoGetRandom", *args, "-o:#{bin}/slivar", "src/slivar.nim"
  end

  test do
    (testpath/"in.vcf").write <<~EOS
      ##fileformat=VCFv4.2
      ##contig=<ID=chr1,length=1000>
      ##INFO=<ID=DP,Number=1,Type=Integer,Description="Depth">
      #CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO
      chr1\t100\trs1\tA\tG\t50\tPASS\tDP=5
      chr1\t200\trs2\tC\tT\t50\tPASS\tDP=40
      chr1\t300\trs3\tG\tA\t50\tPASS\tDP=60
    EOS

    system bin/"slivar", "expr", "--vcf", "in.vcf", "--info", "INFO.DP > 30", "-o", "out.vcf"
    records = (testpath/"out.vcf").read.lines.reject { |l| l.start_with?("#") }
    assert_equal %w[rs2 rs3], records.map { |l| l.split("\t")[2] }

    assert_match "slivar version: #{version}", shell_output("#{bin}/slivar 2>&1", 1)
  end
end
