class Tfk8s < Formula
  desc "Kubernetes YAML manifests to Terraform HCL converter"
  homepage "https://github.com/jrhouston/tfk8s"
  url "https://github.com/jrhouston/tfk8s/archive/v0.1.8.tar.gz"
  sha256 "2a11dc4279ec2995384cb62dbd529ebec027c01d69ab2c1d64346b8bce8987dc"
  license "MIT"
  head "https://github.com/jrhouston/tfk8s.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2e2e554a35f92663f9f20d5182b48e8d093cd7b20acbbb9daf1fbd3c2fb204f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "082cedd2dd68336a0cfda85459c05dc47e7e1820c939aa1c648e92101aa78ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3cb9e3e2fa04aff9647a6cefbf2672581d53c114e24cb7bb1aff53ad369c3172"
    sha256 cellar: :any_skip_relocation, ventura:        "187d9b65edfcc80ccd6d707cf686d784d2ed9b249cb4d19cca6ebc6538df9fe1"
    sha256 cellar: :any_skip_relocation, monterey:       "935cdadbe7d304e663c2b8f6cc0734a8e6a7c623c898f93192a4fbf1fb0812f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "4490b7efa220ab3ddecb2924c8dc8306156f197a66b51b8931b6b565674a674d"
    sha256 cellar: :any_skip_relocation, catalina:       "469a8ecb88db3b79f01e212e7588f6d6a956b2432a904fc294d947857f499dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12e2c6586d3e67cd45691886bec8f011e0fde237a47c901bbbc07f5e7fded60"
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
