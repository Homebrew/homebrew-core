class Tfk8s < Formula
  desc "Kubernetes YAML manifests to Terraform HCL converter"
  homepage "https://github.com/jrhouston/tfk8s"
  url "https://github.com/jrhouston/tfk8s/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "be2680e76311ac7dd814a1bb0dceb486e3511d8d68845421338f9fcf5a92d5f9"
  license "MIT"
  head "https://github.com/jrhouston/tfk8s.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f9b07f68aa49e570daa4a68138d7f16893d524b2e2715df5de719be05da6a61e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e499b7011e3ce354ecbcc659a9dfbd792a4c27a434bc433b591878417c0e1d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c997b7b01ee594d2d0f3e080ac8c3577d2dc49f0165f1af655a6d03e650610d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5feb499b0c5f97e06ab039c8e6c29b25760ef7403ca5d134524c7876e104b630"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae64126f7d4aa6ab26ac854ee30eb7c7bf2ec5ed4e796d4d3d4e9c984c8e7e66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d9655de7508722848160492f9db8fdbd1c8af5916beae34275bc8fa067ff645"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb61ac75407dd370ff45e09ff5624cd1db54714968fa0ad5c4731c0f2e733500"
    sha256 cellar: :any_skip_relocation, ventura:        "fe55588c429a2f74bdcbf062b252b69d15462d3af30ad8694a6e903c07ce105d"
    sha256 cellar: :any_skip_relocation, monterey:       "eb8f3df61a59e34291ea70c2fd93620b2bace987e18a50e15ca6b36e540d68af"
    sha256 cellar: :any_skip_relocation, big_sur:        "3671bf1dfd597f92b38958f4a1836336de5110962d0222b5c829097121a41ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c5aeeca332a3116ad97a6eec394df57815c497b3c1a2f312a4c95c872ce12e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8abd3395c96d3cd264129a5811d98b07e010187b3c7bad9239a77d738c390e7c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.toolVersion=#{version}")
  end

  test do
    (testpath/"input.yml").write <<~YAML
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: test
      data:
        TEST: test
    YAML

    expected = <<~HCL
      resource "kubernetes_manifest" "configmap_test" {
        manifest = {
          "apiVersion" = "v1"
          "data" = {
            "TEST" = "test"
          }
          "kind" = "ConfigMap"
          "metadata" = {
            "name" = "test"
          }
        }
      }
    HCL

    system bin/"tfk8s", "-f", "input.yml", "-o", "output.tf"
    assert_equal expected, File.read("output.tf")

    assert_match version.to_s, shell_output("#{bin}/tfk8s --version")
  end
end
