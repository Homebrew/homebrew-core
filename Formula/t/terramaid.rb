class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "555dda8e7bacb2b4c389d2eba764a50554ca9e130c15f5d0b6fe7f817eaa934e"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77caf01a4a980db936dbaf51f1ef4e379f3a493958fca952120cc768aaba170c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de3b53282dd08af5a2a10cbc2b89eeab98ad14faa4a00594fd44460cbc96c818"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ad7e5a0c8bc6fb5930afd770e174e8ac3e993ac6bc99b4428d740dbd1524960"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8ca7e31410cc1f92d5cc629c3d0f388553bcc18fe14dfaba1b8cbcdae459e16"
    sha256 cellar: :any_skip_relocation, ventura:        "083c64d51e7b7dcff3015f3d231fd93624126241b301e7f961f6006bd75a140d"
    sha256 cellar: :any_skip_relocation, monterey:       "c25e886d0a86185d21fdae5045d09f907e3bf089ae58bce707277ab23449aee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25061aab5135bb818ff2beddbaed3db0251aa104f53c1b8f398f377156ed590"
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
