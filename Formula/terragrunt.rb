class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.24.tar.gz"
  sha256 "9ce5c36a9379e7e1cdde35b9759a1fb1aa36ba07671e2f731f0f8bd62ed86d10"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7f7a1e5b99736f13e43c7efdfcc2263ffb84654e72e248f8ee28283c945861d" => :sierra
    sha256 "07012326b5e813668497b247fe5195bee82c58368b1f70174be73c8f09156a09" => :el_capitan
    sha256 "2871ffc12a658923dc3aa88194877fe615a650c9b622cb0a1afc801ddace771b" => :yosemite
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
