class TrimGalore < Formula
  desc "Quality and adapter trimming for FastQ sequencing reads"
  homepage "https://github.com/FelixKrueger/TrimGalore"
  url "https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "decc7a884b8504a216d739e8a9e26d62e855e5827bc81876bff612281f92917b"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/TrimGalore.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "30545c8ad3e3f8ffed51e4eb9f693d1f3e4b35238f7c8219104b984978621ee8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c3f2a3a15649fed1c875a18b97aa025899ab1ea87b92ae2c42215de762b6138"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27af74954fedb1a00cb2e6d5f105ce2e2e7154308cceef40476b0dc989932c89"
    sha256 cellar: :any,                 arm64_linux:       "0a3c634acea39bce7bf8f777f5cc46406680a28652d6e69b40605a65034a730f"
    sha256 cellar: :any,                 x86_64_linux:      "2c5bc2cb9e8bf838571b1286933ca4d9ac92a41a99d8021526458325020a9742"
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
