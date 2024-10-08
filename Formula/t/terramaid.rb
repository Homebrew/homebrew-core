class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "e9972e4dcc75c93c010b81e7679f857c2dbd560680461b1dc5a47d36f35334e2"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c904635113ea2754cac3a5c381e57fee03d1fdaa6c127d92bbe1060d29d3583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c904635113ea2754cac3a5c381e57fee03d1fdaa6c127d92bbe1060d29d3583"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c904635113ea2754cac3a5c381e57fee03d1fdaa6c127d92bbe1060d29d3583"
    sha256 cellar: :any_skip_relocation, sonoma:        "80877a4f304a479714f14366fe3f033271e3faf51d0f03c2b6a4d9a7aebfa96e"
    sha256 cellar: :any_skip_relocation, ventura:       "80877a4f304a479714f14366fe3f033271e3faf51d0f03c2b6a4d9a7aebfa96e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2572c92a3edfe411165da06822249f5e6984ad9bb02605adda7ce51ed6d10515"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"terramaid", "completion")
  end

  test do
    resource "terraform" do
      # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      # Do not update terraform, it switched to the BUSL license
      # Waiting for https://github.com/runatlantis/atlantis/issues/3741
      url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.7.tar.gz"
      sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
    end

    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: testpath/"terraform")
    end

    ENV.prepend_path "PATH", testpath

    (testpath/"main.tf").write <<~EOS
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    EOS

    system bin/"terramaid", "-d", testpath.to_s, "-o", testpath/"output.mmd"
    assert_predicate testpath/"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
