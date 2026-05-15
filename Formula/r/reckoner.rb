class Reckoner < Formula
  desc "Declaratively install and manage multiple Helm chart releases"
  homepage "https://github.com/FairwindsOps/reckoner"
  url "https://github.com/FairwindsOps/reckoner/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "64def77f2b165a8abe7c2b1f267cc88f61e598a82534cec031ca5ff111798c23"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/reckoner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6636d7200c1016c72dbdd235c03ebf95674ba0df4499ff1307f20157be88bef6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6636d7200c1016c72dbdd235c03ebf95674ba0df4499ff1307f20157be88bef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6636d7200c1016c72dbdd235c03ebf95674ba0df4499ff1307f20157be88bef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a782d984d5056529e56069aba14138815354696bdfd22f37bcceebfd68f23960"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce763a168bb67cdc8d5d6564a7ec163ecce6be3c3715a219678cc980b5ff486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a3b09cf42af4d8da9a1f0cac41947825c37b2c2d14c6ffbda766c9f09732ff"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"reckoner", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/reckoner version")

    # Basic Reckoner course file
    (testpath/"course.yaml").write <<~YAML
      schema: v2
      namespace: test
      repositories:
        stable:
          url: https://charts.helm.sh/stable
      releases:
        - name: nginx
          namespace: test
          chart: stable/nginx-ingress
          version: 1.41.3
          values:
            replicaCount: 1
    YAML

    output = shell_output("#{bin}/reckoner lint #{testpath}/course.yaml 2>&1")
    assert_match "No schema validation errors found", output
  end
end
