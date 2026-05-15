class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "77ce648485030adcb291f098f626aadc052401348e9ac976b98440d2266e3697"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d98f0b5edac2ba8b8377d4cbd17317b9472b2db02b37ad354cd70c3da5d583e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d98f0b5edac2ba8b8377d4cbd17317b9472b2db02b37ad354cd70c3da5d583e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d98f0b5edac2ba8b8377d4cbd17317b9472b2db02b37ad354cd70c3da5d583e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf8a64b90eab44330f895cfe1a6374fe738fab54f1e38e23044414c25efe408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "587ce4e0375a676608c917308d14406351a3c6b59df106e16afea17421472ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935d4cb21345cdcd25090931a15d9a077efa6884a8742b969bf99a0402466d72"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", shell_parameter_format: :cobra)
  end

  test do
    ENV["TERRAMAID_TF_BINARY"] = "tofu"

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin/"terramaid", "run", "-w", testpath.to_s, "-o", testpath/"output.mmd"
    assert_path_exists testpath/"output.mmd"

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
