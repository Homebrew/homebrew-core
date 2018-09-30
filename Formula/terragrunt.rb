class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.12.tar.gz"
  sha256 "283b9f2c64bc59319f0b01e459a2933271ef57fc98d00d5b943cec50f4e826ce"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cea0325ef6063e8130afd783c97224733a9b01988c83aafc5e05e34313dc8a0" => :mojave
    sha256 "03c582d241bb81f5aeb90bf7fd000f1d7b587766ab643d7bf3a7c81e46460508" => :high_sierra
    sha256 "06f9f10ae62a282d0e6c1587139bc6b62f301d49d5d3101033c6a8db31420fd7" => :sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
