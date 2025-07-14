class Unison < Formula
  desc "File synchronization tool"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/refs/tags/v2.53.7.tar.gz"
  sha256 "a259537cef465c4806d6c1638c382620db2dd395ae42a0dd2efa3ba92712bed5"
  license "GPL-3.0-or-later"
  head "https://github.com/bcpierce00/unison.git", branch: "master"

  # The "latest" release on GitHub sometimes points to unstable versions (e.g.,
  # release candidates), so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a438d9f6ebf8318b89efb5a90a75a1f868cc97a6d7cb946fc4ccc8e6e2eba8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b4395fbbe4b611bdc416c5259d92dede2513075efc54aa2dd45cfdf7684bb44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cdc258a6195ed8bf7d6cf8b133514b9095d78ac2959e6046d799f21c5b0e060"
    sha256 cellar: :any_skip_relocation, sonoma:        "31775a533d0d7564451e30b2e733b1cafacba867c350a39419299831b7c56bb8"
    sha256 cellar: :any_skip_relocation, ventura:       "44fde2dbd196dafa390ced91ad35cea7c22e65ea2a32462bd626459b80bd1af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b57e871a883112dd1ebb85cf7862e1be1224ce27856e2de283906df7bc068b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "791845dc0fad058e50afecf62cd4ce75c65bde67cf3c2d3b28743d46ba86c8b2"
  end

  depends_on "ocaml" => :build

  conflicts_with cask: "unison"

  def install
    system "make", "src/unison"
    bin.install "src/unison"
    # unison-fsmonitor is built just for Linux targets
    if OS.linux?
      system "make", "src/unison-fsmonitor"
      bin.install "src/unison-fsmonitor"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
