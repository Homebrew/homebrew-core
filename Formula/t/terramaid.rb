class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "d94476cf172b410b71840773aa41f378a9b27aa14e998e2fb2887ffaa710d37b"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ad9dc033b9dd1010c2b4b178cf517738a5f20d0d65762af4e9086e809feeea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ad9dc033b9dd1010c2b4b178cf517738a5f20d0d65762af4e9086e809feeea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ad9dc033b9dd1010c2b4b178cf517738a5f20d0d65762af4e9086e809feeea"
    sha256 cellar: :any_skip_relocation, sonoma:        "47cd6c87199fb69edcd8295ed9b2ca59c439b7a81d5cbc71fed65f6a33317a3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6bdd36f3a8ba5ac37d3aa1a731e6d724cccd2ee1bea517b7dda5fd98a99cae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658a98a98bc45c6ab633ded06628a5296bb6597686b92a22f675cd17409ff15d"
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
