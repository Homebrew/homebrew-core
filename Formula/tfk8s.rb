class Tfk8s < Formula
  desc "Kubernetes YAML manifests to Terraform HCL converter"
  homepage "https://github.com/jrhouston/tfk8s"
  url "https://github.com/jrhouston/tfk8s/archive/v0.1.7.tar.gz"
  sha256 "02607090e93ed081dc0f926db4ca08cded6b31243977726b8374d435e25beab9"
  license "MIT"
  head "https://github.com/jrhouston/tfk8s.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60e7ac0c249bc2685997731a51b363062cb9878ba6fb1d2b7772285ce3abadd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1b1a9bb816036abc0784dfe452695e60c1c68afd115e67939d3d433e86482b1"
    sha256 cellar: :any_skip_relocation, monterey:       "39b84355ef177d210193b06cde1ed3869a5a2bbf08ec6b5f144dd8507fb69c4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5f31892d190ba1efd7022a82807897a6425541eb9ac4145d6ee1dec65b9182c"
    sha256 cellar: :any_skip_relocation, catalina:       "6c59969d1485a8da95fc91f36651f66e408ab914dbbab5de7506c7116984eb18"
    sha256 cellar: :any_skip_relocation, mojave:         "5719e16f622f7b70c2ddbcab9e3eef4e4039f5c73be904608ac50bc7d515031b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7957afd5e810dca0c340a217f9ddafae13ed173dc10d8b0cc7642607a3ad72be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.toolVersion=#{version}")
  end

  test do
    (testpath/"input.yml").write <<~EOS
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: test
      data:
        TEST: test
    EOS

    expected = <<~EOS
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
    EOS

    system bin/"tfk8s", "-f", "input.yml", "-o", "output.tf"
    assert_equal expected, File.read("output.tf")

    assert_match version.to_s, shell_output(bin/"tfk8s --version")
  end
end
