class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.6.tar.gz"
  sha256 "0a628f8ddc184d4fd12ac3569e8fa5b005f6e37408910029a39434687c93209f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "47af5bb2f5167f00105a538fa0f2e39edd2a4c90e17df05cb0f687034a061d0a" => :mojave
    sha256 "fd69c60310f616ed3dfb600f322334a6f8a0dedb26be9f90321719670f18ef6b" => :high_sierra
    sha256 "306093fd54e15155fc3483d17cdc9e33f628dd8be35d6ca3469d68f2e1d23ae0" => :sierra
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
