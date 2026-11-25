class Reckoner < Formula
  desc "Declaratively install and manage multiple Helm chart releases"
  homepage "https://github.com/FairwindsOps/reckoner"
  url "https://github.com/FairwindsOps/reckoner/archive/refs/tags/v6.3.1.tar.gz"
  sha256 "b5abed69ac46c99b105b2a80be26fd107a8f10ebc4ba957ff534c692ac201847"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/reckoner.git", branch: "master"

  bottle do
    manifest_sha256 "a58bd947342b93935fcc1317e95778a062072ee2a2ea2cb00938bb409f9d55d5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db4a2d09d46770f7857d3a71812461e8b930c5e652d65266e05950631e7f4d90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db4a2d09d46770f7857d3a71812461e8b930c5e652d65266e05950631e7f4d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db4a2d09d46770f7857d3a71812461e8b930c5e652d65266e05950631e7f4d90"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4f68d53966152166ea1ced9085129dacff8237eb90c34bf0a1b2861a1d96bc95"
    sha256 cellar: :any,                 x86_64_linux:      "140c3e2636e91516b13f970c3abaebdcb1415f4a6108110157c13462f1ac7a6d"
  end

  depends_on "go" => :build
  depends_on "helm"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
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
