class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "fb7a6686e5d8845e457a0838ad689ea654beb569283b80591bf59556dee3bcf1"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9abf66f02f175a1ee5a3ffb00dfa0d67bf67cdc51b66d68fd9a1b92925c6ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9abf66f02f175a1ee5a3ffb00dfa0d67bf67cdc51b66d68fd9a1b92925c6ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d9abf66f02f175a1ee5a3ffb00dfa0d67bf67cdc51b66d68fd9a1b92925c6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7d9d4df774d6be1ec76e26df93fbfa26c9936cb3ca813a3fa84092c20b9008"
    sha256 cellar: :any_skip_relocation, ventura:       "5b7d9d4df774d6be1ec76e26df93fbfa26c9936cb3ca813a3fa84092c20b9008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423a09cccf5152a5db5e2272b0d277297f4655266fce49017b3430fe0722b3d5"
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
