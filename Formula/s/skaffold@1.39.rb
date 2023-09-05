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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e7ce1442bc4d389bf776673b506a6c16558d94711e0eb0a377de96d38e2247b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bd9d29c0f720e6edad0f629e26f695a52ad7282bb5997b2bb1d85551c7af24c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c2a108c0f7dee22068a7d38f753d88dfdf6fff0d963da805540a680f90641bc"
    sha256 cellar: :any_skip_relocation, ventura:        "3866498ece7fddc38f170484fd0934d9c9ce3a48e58a97083c171a28426632b1"
    sha256 cellar: :any_skip_relocation, monterey:       "292843314563aa8969a01f3d1386cd11f24bab0a08f7e17e9cfc720613003726"
    sha256 cellar: :any_skip_relocation, big_sur:        "95c54ace19027f5669c915163929920b42957054be587f2ba47e802ae7bf4af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f0da74df59c9f46b1a933e51226415fec9ed61506c2ba52bf9cd5d38c0532fb"
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
