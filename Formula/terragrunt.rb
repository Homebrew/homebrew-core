class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.25.2.tar.gz"
  sha256 "f3d2008ba843e3ae604e067cdda59f24639e3d986abc5e1ecd6f064c0e4776d2"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fc02d01017a9dfa88829c7cc1ba1c885088f61832b2522c743782a2834e8d4c" => :catalina
    sha256 "aa75c588c8dabd79413ffe19d096b8c6adda518cf1c39a6e16131ec531a72216" => :mojave
    sha256 "6357820dda43cf505d73529afbf4e33a02b4fbe821e810396e169db68a8ba5be" => :high_sierra
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
