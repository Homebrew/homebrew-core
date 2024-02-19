class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.10.1",
      revision: "df0264229733d654ae0f43466e760dae936b12e7"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ede5d04ad6c024d9853964053d0337d793c96fcaa379ac230d40d5377ac4033"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaec7a010986fbd1f7f8b3b9c9d80f4c836e8adafd4ae1b151601dfaba5aa488"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f764806fdd5be457e70e6bd1e3ce81fe78c99465e2bac52bd16d95aefadefe5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "72d375fe4507271fbcccf1d8fa803dc6bb25757dc097aea1b733b170e630e984"
    sha256 cellar: :any_skip_relocation, ventura:        "d8e32fa5371e0d830d82143da7c66e6b169649d8929dcb67e6310619f2d5d7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "23aefc32abcf4df37cccc29a7ef0cb0f88be10b24e3040bb72d472839aa6429f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0ed83ee1ceecaa82429bf8dc0a9ded869c94abf27bbf5f82a40e2f05efd33d9"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
