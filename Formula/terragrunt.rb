class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.10",
    :revision => "7f563c6fe3abe41764aff642f01edc180288a9af"

  bottle do
    cellar :any_skip_relocation
    sha256 "116e39aae20dfdfb04844d9bdfb680130dc34c005d46bdc5b835d2c29cfc2556" => :catalina
    sha256 "dbef2c3c3549dda6e25ea84670025bc598158adc54e81e044d099a028aa7c0e0" => :mojave
    sha256 "194c374e2da8517e0144fde32f2d8061f3bce805bd7b868b7dddb5d0ac0d1ff5" => :high_sierra
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
