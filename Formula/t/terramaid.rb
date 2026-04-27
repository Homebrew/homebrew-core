class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "81b4cedcbcb8be868ec50cea71203bf8c2250ee08c3520cbe070e8ed3d1152f7"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3931e901a01732c650657e08532afecb1e1c809020bdd5f270a2e45ccd16e75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3931e901a01732c650657e08532afecb1e1c809020bdd5f270a2e45ccd16e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3931e901a01732c650657e08532afecb1e1c809020bdd5f270a2e45ccd16e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb845ce8cdbcd9654f0a3246d7a9abaafd51057b8365ad2636e90233da9a08fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9065d6b95f995a6b003a7a30835f490c363628eb551bc1dfaa11fe0bd226e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "511673b0c8fe0458f29ceca25de1533bf1d49f8dccf3f17489509c7bf55eec7a"
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
