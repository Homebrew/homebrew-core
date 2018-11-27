class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.17.3.tar.gz"
  sha256 "5502b87131d642886cfcc5266092f7360b27f4f3f21b6dbb1f3ac2996dcd7da5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97f03a78c0362e789fdd8d9bca5385e5a9c32b2cff1b3b6bd8c41e25c37189c5" => :mojave
    sha256 "02f82aa4820ae881777183ef8a978ce1b56f0ce05d6776a648c9a3fce8235105" => :high_sierra
    sha256 "c5a42572202a23a8839f1bb3ef981c3eec9af4434e539cff74e12669a90fc5e9" => :sierra
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
