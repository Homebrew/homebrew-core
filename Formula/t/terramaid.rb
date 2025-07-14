class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "452647a8f06bef671da1df3c33a798e1cb560f94cafb9ddd0eb46c49611c5131"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349342ac214149a3324286da16ac57d06cadf7c1497ab37da640199dbdff58f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349342ac214149a3324286da16ac57d06cadf7c1497ab37da640199dbdff58f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "349342ac214149a3324286da16ac57d06cadf7c1497ab37da640199dbdff58f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0f06b28e149b6b57ea4bf4f33eb45a59237212a0cc123f2915c775bad0a35e"
    sha256 cellar: :any_skip_relocation, ventura:       "ae0f06b28e149b6b57ea4bf4f33eb45a59237212a0cc123f2915c775bad0a35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c78e7268d8bf3b76863641a290b567d4b24333d196156780f54ba4fe6d390c5"
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
