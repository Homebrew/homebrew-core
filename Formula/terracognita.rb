class Terracognita < Formula
  desc "Reads from existing Cloud Providers and generates Terraform code"
  homepage "https://github.com/cycloidio/terracognita"
  url "https://github.com/cycloidio/terracognita/archive/v0.6.4.tar.gz"
  sha256 "b9282055bf2235e0f8b9fbc1ae31c22909986ee3b3df5cc64e644b34f6513485"
  license "MIT"
  head "https://github.com/cycloidio/terracognita.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cafed794c34f72a5e390a1bdf821798d33c55c567c6b4fa1348d800f3584711"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cf78bf712f39334a49d05faed61c57c5ae431b2da03e2978462c51c6108133a"
    sha256 cellar: :any_skip_relocation, catalina:      "ebe755ce13ebff04cacce0edf79b3af170c490c53265ef2fd3ef0ac87a3359da"
    sha256 cellar: :any_skip_relocation, mojave:        "2b38f5cdbd101cc038bfc6ec0570c9b989ae358e7ed604134e9bd41a8155b275"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28151589641507d8c0da31316b3a25bd4332b63684903286ed4620e1b61fccd"
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
