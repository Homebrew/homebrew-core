class Recur < Formula
  desc "Retry a command with exponential backoff and jitter"
  homepage "https://github.com/dbohdan/recur"
  url "https://github.com/dbohdan/recur/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "cf776be19cf0e55c7e8a29b546d813e1dc562c05b220cba291cb4812917bd6a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149117659c69734078b7f8fc1b04dbd5e2656460b033bff06669ca1f48e9bd94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "149117659c69734078b7f8fc1b04dbd5e2656460b033bff06669ca1f48e9bd94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "149117659c69734078b7f8fc1b04dbd5e2656460b033bff06669ca1f48e9bd94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "149117659c69734078b7f8fc1b04dbd5e2656460b033bff06669ca1f48e9bd94"
    sha256 cellar: :any_skip_relocation, sonoma:        "23ef406ebd94bc895b9af4c80947ebeecdcf8a5a559949c0fabc9df4cf00a161"
    sha256 cellar: :any_skip_relocation, ventura:       "23ef406ebd94bc895b9af4c80947ebeecdcf8a5a559949c0fabc9df4cf00a161"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ea2a8a6fb31399baff2bbeb66117a8e7196b509bd88f5f5be7bcd1ff48c3adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afadb0c61c3dffaa2203399824a6debcd7cc82ef28b1f50f18a226a25d2869ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/recur -c 'attempt == 3' sh -c 'echo $RECUR_ATTEMPT'")
    assert_equal "1\n2\n3\n", output
  end
end
