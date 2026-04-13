class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "3543a33761a1070fba71ae5b9aa3bd4924d02a67cf50d35ac3e9bfae21ee3a3d"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86f5e78ed125cad096d90ea8e4f6921896f7105bf77eb79f50d4c195b27156d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86f5e78ed125cad096d90ea8e4f6921896f7105bf77eb79f50d4c195b27156d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86f5e78ed125cad096d90ea8e4f6921896f7105bf77eb79f50d4c195b27156d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8739309c6c05c1a9caea6362b5e73335c48e7c9af008db3fbec0a5a8a91204d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5009eb0f9d369d2efdd47b73fa19aa0a80e42547499b51edc2cb7ace84346d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a102c60680ae22e671cdefa99b31813b3cb1cb97e18eb4b7ee747288aedde70f"
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
