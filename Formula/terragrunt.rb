class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.0.tar.gz"
  sha256 "c33a64d2ea7da1a0c728c1b5f4b7f9d3517b764cdd8173e4a0504720ea4dc822"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e859363a12ab35c8f7924eb5c8a9a04d6d72a0dbe0fdc08641a9991837b932" => :mojave
    sha256 "038eb71040d7ffe5cbca5ef042a482bacd5631bb4244de4e8de56c85547c4ab1" => :high_sierra
    sha256 "b386090efa6b57fda762e9b9fb4eb714721bcd9b1a1863c7a4b04f23fa337fc4" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
