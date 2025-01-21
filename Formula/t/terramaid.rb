class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "43f4fe29997f3090ef82b3e46893426c88be5ea991e9c61966ef5660a40ae851"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b708fb015e343fd29aa37342862ebc9a72c3a56f94dac88da396e29d9170e3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b708fb015e343fd29aa37342862ebc9a72c3a56f94dac88da396e29d9170e3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b708fb015e343fd29aa37342862ebc9a72c3a56f94dac88da396e29d9170e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21c7c598280a8abffa40957530bb551694805449f224f443eb9f7d411ad6cf79"
    sha256 cellar: :any_skip_relocation, ventura:       "21c7c598280a8abffa40957530bb551694805449f224f443eb9f7d411ad6cf79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39be4c218d20994c8b69045f94711ed4ef8d9c767770c81a17d385147bf27e00"
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
    assert_predicate testpath/"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end
