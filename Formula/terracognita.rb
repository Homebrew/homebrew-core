class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.7.4.tar.gz"
  sha256 "7027103c899d29b86dd1dc72e1e2d6d685bec6311673f7fbd31c8127ccd62c82"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aea1bff9cc6e54a5a6f2328a0bf8c149110a7ceddc475ef256f70d271083221b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d86a19285ec82eb5c63d5f8a1506d5208495ea1824beb87cea1ed24b300fdb68"
    sha256 cellar: :any_skip_relocation, monterey:       "fcfa8f7bd74c1d2214e0ee1e90d2d5f89b5421585cec86e35dce6b01d16ef014"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b54d5285bc814e82ddd4a436fad0f0a136f643777a3954ef2ad2c03a5afce03"
    sha256 cellar: :any_skip_relocation, catalina:       "cbb46e5d8cda59aa40d57db85f05c6e8b86cceb13ce5999887bad3f541029776"
    sha256 cellar: :any_skip_relocation, mojave:         "0acf733131cc484c14a9276aa8b7c0611f3e7faec0a2d70ebef8149a53f214f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6222d3967d26904d5894855669f39662322f6ead05759ada13776c906f7ed21e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
