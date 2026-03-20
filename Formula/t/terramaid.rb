class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "13166a17639fc2c7039eb27545d7c411c9aa6bbc188f7513124711a5667e06d8"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "672bf91502762faf0b8f9e8ad5504809ae1181df8d88197ada1b4a39147d34ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "672bf91502762faf0b8f9e8ad5504809ae1181df8d88197ada1b4a39147d34ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672bf91502762faf0b8f9e8ad5504809ae1181df8d88197ada1b4a39147d34ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa6139e8c8aad8ba20959e9829729ed52be0da05914bbfea9a48883b8ed50ebf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b0bbc1f6f01e1d04ce17847a38bc400b999a7375d82b6fc0d5f75a37d3c215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58a6329121b05445bdca335d2b27948c43fbfb88169b43251217ba163557036"
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
