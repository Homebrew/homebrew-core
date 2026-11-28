class TrimGalore < Formula
  desc "Quality and adapter trimming for FastQ sequencing reads"
  homepage "https://github.com/FelixKrueger/TrimGalore"
  url "https://github.com/FelixKrueger/TrimGalore/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "1e45c78d4bb3f2b9b9cef8c54fadc4b0bc874061091c1c67b2d4ffacd6ef86dc"
  license "GPL-3.0-only"
  head "https://github.com/FelixKrueger/TrimGalore.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4e5f339de70445e56cba7b861fe9bf2f8191ba6e642b5bd5080ba4ec7dc49040"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c76e3d0e4e28b7b01c0c45eff72423fe693fdcd30f9da965df40aa1c211e45c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "745f09adb68fc85785fda1783b23807326e0f9b1828598727d748a021be950a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbfe987ec7e4173e4dd43e0ff79c7063beb51928949c86b5d64cadc29260ca71"
    sha256 cellar: :any,                 arm64_linux:       "65e84f728de9d2acc769bbea1b514441cb213b96c38d44bfb80c4a6a083be3ab"
    sha256 cellar: :any,                 x86_64_linux:      "7919ea95001bea63b65a7c192abcf29a10263c33e454f84ebe4ff239e82468e9"
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
