class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.8",
    :revision => "a3da7e3adb71fcbc18b964172f64a99aae6fa98c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd79bb55dff67214fa6703a8b24cef66d29313c97e396d1b5138e603fbbaf2b1" => :catalina
    sha256 "d8323ddcd99a8766e2656943b3c1cdb84e8781532281ff99a4d21b1b8d5773e0" => :mojave
    sha256 "0cdb79ed161f4d5c8b18f0905dc2044be49a7b9ebdd13747eaa7f8db6d266ad9" => :high_sierra
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
