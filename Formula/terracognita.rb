class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.8.3.tar.gz"
  sha256 "7713e4b93528c294db86d008a2ab09ed841984ae2d1ea6f58c3703dab3a1b21e"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dba3501e403d8c7315facde5e19fbb32a1e10cff34b97c0b86f2f21ee2afb52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dba3501e403d8c7315facde5e19fbb32a1e10cff34b97c0b86f2f21ee2afb52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dba3501e403d8c7315facde5e19fbb32a1e10cff34b97c0b86f2f21ee2afb52"
    sha256 cellar: :any_skip_relocation, ventura:        "888ea75087b27f590bc0186699075746cabe055ff236674af0beb7321d501760"
    sha256 cellar: :any_skip_relocation, monterey:       "888ea75087b27f590bc0186699075746cabe055ff236674af0beb7321d501760"
    sha256 cellar: :any_skip_relocation, big_sur:        "888ea75087b27f590bc0186699075746cabe055ff236674af0beb7321d501760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d7928b8f0fc7c7db4d99ea940f8aa83b42b66decfad624f45da2f8a52b143be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cycloidio/terracognita/cmd.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/terracognita version")
    assert_match "Error: one of --module, --hcl  or --tfstate are required",
      shell_output("#{bin}/terracognita aws 2>&1", 1)
    assert_match "aws_instance", shell_output("#{bin}/terracognita aws resources")
  end
end
