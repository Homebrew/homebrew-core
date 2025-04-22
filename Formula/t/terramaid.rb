class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "75c6d87aac78397ff3c7b54bd963b1624a3d24d9507c3377fe127ee5a3862d5c"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a551cff811a599349a4106d29bd467cece4098bdcd96a38b7563e1c2851269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a551cff811a599349a4106d29bd467cece4098bdcd96a38b7563e1c2851269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12a551cff811a599349a4106d29bd467cece4098bdcd96a38b7563e1c2851269"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc20dc9f7135d34b801269d2d252013787c3b847b1385db7ae33e797077df6a0"
    sha256 cellar: :any_skip_relocation, ventura:       "cc20dc9f7135d34b801269d2d252013787c3b847b1385db7ae33e797077df6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0b20d4ec0bdd2a037d6c16920ef2c7cbe005492fd1871dbc5a8234f9406aa49"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", "completion")
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
