class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.14",
      revision: "ab889d7065c6039a4826ffe1f0eff8faf8939b9f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f2ddfd2965d063354ec20e8255d371d35f9c29b7cbfd6fcfe41835def7c8447"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "606b85fbb605475dcb41508572ce3927970050127a8eac3da21a584313f15d93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ecfa3bcc63e2281816a2474590ba9ba9fa801d1056b43818771e07b3c29e18d"
    sha256 cellar: :any_skip_relocation, ventura:        "9224ef9b90fd2d7968ad7b5cc3644acdfea6654b9dcfc559b623e402d849c0ca"
    sha256 cellar: :any_skip_relocation, monterey:       "46691fee9aeac1af10b077a3a61e9489093359862897f9e4cbb88f0fe75bdb8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e760a134ce71d61a91283d71a348a2e9dfc5befd5d0487697dcf775fc5a96a90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f81805609d00cf837eaaae26ba9ef0d7ba68838b408f6f2e92a9684891b42889"
  end

  keg_only :versioned_formula

  # https://cloud.google.com/deploy/docs/using-skaffold/select-skaffold#skaffold_version_deprecation_and_maintenance_policy
  disable! date: "2023-10-18", because: :deprecated_upstream

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion", shells: [:bash, :zsh])
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
