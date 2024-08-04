class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3c38f6e9b7539fcba785dfa8063a5a35e1cf1c3d90712a31e354b6d1017b0673"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ddbdcf5cda64e4b5d16b99307a6a64a0b9046a9756e9c88ec44f99f787d56ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac83ae182bf1480d1b1f5646c91cbfe5f9b7f35f89eba81b0deb58958c369a4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6d4d90c833fbdc9718168a5fe2d79e20106e97ccd47314a765151693f470cb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "536d94d1ee405af53d6b7a06f71f4ca64ea686216bb357ef1441e2dd720815f9"
    sha256 cellar: :any_skip_relocation, ventura:        "3182380f24f796bcfbeb90636cf6b029c3aea7dff4744a8298264fa59789e7d2"
    sha256 cellar: :any_skip_relocation, monterey:       "ad4cc89d76dd370a4835cdf9dbe1eb89bc8d5e0879400d826fda1ada862dcafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278e7b7b42b31413d30645b1b6365a2b905268f12725ddd04c4c10cb679e58a2"
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
