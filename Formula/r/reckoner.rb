class Reckoner < Formula
  desc "Declaratively install and manage multiple Helm chart releases"
  homepage "https://github.com/FairwindsOps/reckoner"
  url "https://github.com/FairwindsOps/reckoner/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "7d43511db233739f1584c2d0875333c97a9470b4689dd2d65a36d1d591096d7a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/reckoner.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52f96d24f75c2000278fe7ed91fe73d982683297d158e118e345331d24580804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f96d24f75c2000278fe7ed91fe73d982683297d158e118e345331d24580804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52f96d24f75c2000278fe7ed91fe73d982683297d158e118e345331d24580804"
    sha256 cellar: :any_skip_relocation, sonoma:        "d14ba71c34740a9dd2ae9bbf97fd3f118dd1dcfd92bc267ef69d7daca27d8a8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d20750b1c3e9b5c39f9c67970c2dd9295769a9d2fa3a581ce61a9d4a4ae546ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d44c9b58fe4752068e76ff69d1201a31434564482c05a7242220e4bf5fe26d98"
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
