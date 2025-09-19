class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "e448b8671c8d5fe70aa2d8b22b1cbc074fc89bf751b212d9d19f298821afd487"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e1e2c426929b914905c827f9b35aa50789fc07316ad9a6bd4d673eea741b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1e2c426929b914905c827f9b35aa50789fc07316ad9a6bd4d673eea741b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e1e2c426929b914905c827f9b35aa50789fc07316ad9a6bd4d673eea741b8f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad356c90ad9687a54ec5e5858b8822dece1ced6960b243dca37e900abc07649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e354b3f9ecd904eaa3d44871c1b4f4e37e448b4145bfdeaeeda41f11631af5df"
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
