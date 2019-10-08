class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.19.30",
    :revision => "39dcc2e62fc13496ffaa08e923fdbeb8f5f935ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5fe2d7c3f554611418fbaf5dee25b41138594626ab1e42c7efc7cb9275a8318" => :catalina
    sha256 "87204c2e8af3eb4471bad93beecf024ac2441d621e5a7fd8310bc630e5dc0779" => :mojave
    sha256 "8b2030a308513a45f833adc3a86cac61719d4be3e3b5a5d5b206086673afbea4" => :high_sierra
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
