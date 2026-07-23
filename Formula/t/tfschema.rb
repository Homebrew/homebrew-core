class Tfschema < Formula
  desc "Schema inspector for Terraform/OpenTofu providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "7d028adc987d4cb7896556df1d727270396e9790a734700fbd867c2e3a62c211"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b174c50761ec68cf29cd2d1f617d7b08d038c94ab2fdf44d2ffeac851290788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b174c50761ec68cf29cd2d1f617d7b08d038c94ab2fdf44d2ffeac851290788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b174c50761ec68cf29cd2d1f617d7b08d038c94ab2fdf44d2ffeac851290788"
    sha256 cellar: :any_skip_relocation, sonoma:        "718b9d42ac16fdd4bf8cbe77398586299b4cdd903181385325b4abedbcb2504f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40855957a6ad1ea3b2af91adec960953ed55c06edca96494e35970a7b375d2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d6a3969a16779afb6cc0526f1d880f65e27a266621467311f7c75c70d1484c3"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["opentofu"].bin/"tofu", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
