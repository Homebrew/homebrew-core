class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/5.1.0.tar.gz"
  sha256 "c58ee8cdb2e40c921fbef4b8ceffcb7999687b473152f942a6bda0089da6b256"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84e4c2e53b22b7694d71ea8101fdbf6eff284c1f33b910e6294e5caf835367be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa84277a578b086b7ca25187150b4fb85074c15ebc2d7158a2a32422d404d43e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5a9c290c011b8ba91865c5e72497a803b78724682dd07f2dfdf86609a462bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd5eabbce7f8187d33ee041e00b65bd833a9aa8c72d4b38638effd74cd57e37"
    sha256 cellar: :any,                 arm64_linux:   "930b293dea8704291bf7813cb533330bbeb0fe1a6adf90ec8cc6ff71515cb4c5"
    sha256 cellar: :any,                 x86_64_linux:  "0603d85ca2e35d78f396eadec3212371e1bf6408ff422adab204d982a5f8e0a8"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end
