class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "8b5faba19093664ebdf504d8bdb38fe5f37de06c9dc6e6a3939564ec34a8e692"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5deb74301c7852a0a2f3f694bd59b45eef093d121936aa907cdedf0569be19b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5deb74301c7852a0a2f3f694bd59b45eef093d121936aa907cdedf0569be19b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5deb74301c7852a0a2f3f694bd59b45eef093d121936aa907cdedf0569be19b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "28e26828a20ee7868f9fa929b20957a56605e3e0dd2d0b1b54927b5c019161d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ddf1c2e1d6bd368251cf99ad079c879a9598e63d31f69b8db310f784093ca98"
    sha256 cellar: :any,                 x86_64_linux:  "c1146e76edb44538f2252fbb80fd13ff11c6f700f6cc5e88337f27cb3a0d7bce"
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
