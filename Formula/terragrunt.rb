class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.8.tar.gz"
  sha256 "6ad9d21dd6958ef678e854341c7c95100dd7e945ef3bbddab02b05d1bf3c427e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56e2a2066a66ecf438c1fa5ebdcd74c843d9d563107c681ca26cede7a33befa3" => :high_sierra
    sha256 "b5c0cc3b87f6ecc7dfeb7903f11d0b896bbd57b1d2aaf518045cf9ac4c1c7f26" => :sierra
    sha256 "deba5ef427990d8ddea973cea0eed43a6d092643a13d8dc0259e42cd6b0fd775" => :el_capitan
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
