class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.6",
    :revision => "7be8eeda754fa1449265cd48356ec732c879ad90"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee3fdd0a7dc5034f85ac102176bdc31f198335a07a5208c7ef0589c729a38a0e" => :catalina
    sha256 "5efb5b254fe215acf133ae182429c98041477d55d0ffb321366de3b3fae47902" => :mojave
    sha256 "75cc3e08ee14ce2053dd0e4a29c01d2df6bcbd2436cd9e851cbaabb2c38d1188" => :high_sierra
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
