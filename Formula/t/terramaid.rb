class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "3a85730ca72bdc745280b91545b56d97e0ed036f688424c62e397b9769317fc0"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fcda64b41a1bb8de330a0c31d57415193361baaa83991a6c5e6e9c7382fc955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fcda64b41a1bb8de330a0c31d57415193361baaa83991a6c5e6e9c7382fc955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcda64b41a1bb8de330a0c31d57415193361baaa83991a6c5e6e9c7382fc955"
    sha256 cellar: :any_skip_relocation, sonoma:        "28603bc13a762ec70d79798f1590b3d12c4fcbddf436cb1e0ffabdc828847fab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c50bbc0d9f48f346431cfc3af1e104f42ef34d92132bfb9bf778629801b3014e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9be9970b5a490dfa4dd4655c8965657195601c3144225b157cbeb1ace9e5fd3"
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
