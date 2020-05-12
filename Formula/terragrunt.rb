class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.17",
    :revision => "f48b5960a17dcc014ade9906fefa1a3bd6e4ce1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2e428af9285cd6f120c26b99f875f7cd653abfc318080533cd440bae6c71148" => :catalina
    sha256 "65648c0d1c7f6111db08bf77c215f9e47449a172e7a42a7dbd3ebe3362a59323" => :mojave
    sha256 "6f7d0ae6194405e653944438cf40eaf80854feeccacc269020b84bb078a18162" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
