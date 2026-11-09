class TrimGalore < Formula
  desc "Quality and adapter trimming for FastQ sequencing reads"
  homepage "https://github.com/FelixKrueger/TrimGalore"
  url "https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e88fa19e71781792e469f7f0ed8a85272b4ede9518a0f41d7babc81be6e32dd1"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/TrimGalore.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3500933be041fb5a2fb1d8c9ed5a525cbe2b649bd079c0c1acbf9203aeeb96d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "38581836c7b2b22c709e59d395587fe0cfeee03836b80aed64f5fb318289c002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eb30b443fdae6cc166618ca9d998daaffdd9e33847c1bc774bf1f96ab5860c48"
    sha256 cellar: :any,                 arm64_linux:       "83d3ea32e44f60ed98aceae4269e953699acae915860b1bd5b49445e819419ad"
    sha256 cellar: :any,                 x86_64_linux:      "32d7754e5fc8e7d84d01fdedfe5fb2df947d255ee498836badab6234e85420a1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trim_galore --version")

    (testpath/"reads.fq").write "@r1\n#{"A" * 30}AGATCGGAAGAGC\n+\n#{"I" * 43}\n"
    system bin/"trim_galore", "--dont_gzip", testpath/"reads.fq"
    assert_path_exists testpath/"reads_trimmed.fq"
  end
end
