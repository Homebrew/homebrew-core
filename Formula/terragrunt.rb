class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.21.tar.gz"
  sha256 "3dbc0028b97e952857c819e1422187bd1cbdc83b6a002711de64f914e586e08e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "78247b50802252ad9f35b966f9fed508360ac7935c0d834a49df48c5671c2277" => :sierra
    sha256 "aa4f444cb6805d2cc9e7363b62e27c088b87e02fb9bb5fcf5f5fa515ca0744bb" => :el_capitan
    sha256 "629f8bf3717feb2c1556b0a0d07ab287afc2989d831b814e70ea74fa0a4e1ffe" => :yosemite
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
