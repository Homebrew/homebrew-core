class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.7",
    :revision => "042ec65d977c9c757781b6c172d4b732b7485a07"

  bottle do
    cellar :any_skip_relocation
    sha256 "45d4621072962a6b0aba8ff00a27e6e8c9a00b1e6fb9bc4a96c0f2705274b084" => :catalina
    sha256 "734a0806a8318c2e6621607b32c3518e6ffa2e0fc780d8bc1a4555fc69f1c3a1" => :mojave
    sha256 "34dd48fc4e4038c45795b2fe180dfac902dbfe8a2d4b1200b1a18fcc5445cc4a" => :high_sierra
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
