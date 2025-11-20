class Reckoner < Formula
  desc "Declaratively install and manage multiple Helm chart releases"
  homepage "https://github.com/FairwindsOps/reckoner"
  url "https://github.com/FairwindsOps/reckoner/archive/refs/tags/v6.2.0.tar.gz"
  sha256 "7d43511db233739f1584c2d0875333c97a9470b4689dd2d65a36d1d591096d7a"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/reckoner.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03aea7e1ff644a4073e2434ff7ae3c883bbc6bd394b83a2aaecf2eec4a586381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e819d54160c7f34ccc327200798bee113bdfa2cac49ce7c73b7b80dd1dbb6512"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e819d54160c7f34ccc327200798bee113bdfa2cac49ce7c73b7b80dd1dbb6512"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e819d54160c7f34ccc327200798bee113bdfa2cac49ce7c73b7b80dd1dbb6512"
    sha256 cellar: :any_skip_relocation, sonoma:        "562a31411a4351cedcc0bb15a92147836bcf3444f36b44086e2bb4be34e8a808"
    sha256 cellar: :any_skip_relocation, ventura:       "562a31411a4351cedcc0bb15a92147836bcf3444f36b44086e2bb4be34e8a808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f840ec2114c6a8ac13d7c81e0562b1bf14b20c58407f644abdec811b623d6b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a04b4b6ff5871fcc12e09cbfe65a9b8b06be2a9a3fd90d2e8b8337100b0087fb"
  end

  depends_on "go" => :build
  depends_on "helm"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user}")

    generate_completions_from_executable(bin/"reckoner", "completion")
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
