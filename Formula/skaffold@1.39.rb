class SkaffoldAT139 < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.39.17",
      revision: "dfdb5d3538e19a86304195668742b7c11d507c42"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.39(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71bd1d3efa3fb030467c17099e0533397862c6b17f0a96ea6aced1472f8b0a90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0ea6a1c7bb31fa3a606889b46a2528c407197b9559778e08f682c0217400eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c6f748a5ad851a2ebe31e82f134c9eb957a18d3f98faf91a28b26f98042c8e"
    sha256 cellar: :any_skip_relocation, ventura:        "345a114a2640fdcebdbf396c98dea63a0601a217c8f3f2fe12ede8948f7cca21"
    sha256 cellar: :any_skip_relocation, monterey:       "3c21f3e49d65f2e2c85569670b5ee24fad47b0b075b8f2d78c7eea5259db2b43"
    sha256 cellar: :any_skip_relocation, big_sur:        "51e1443f05b1a8a16291d3fbfcbe224628af26bd475c82dd1fad2e6911a441ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94804f2c0e38bd4b9d63d2144d81464304b41b173aa49f20e7ddf07f870070b0"
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
