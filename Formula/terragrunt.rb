class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.9.3.tar.gz"
  sha256 "cf874700e9914d5e6dcc30209dfe2e638cf9d5a548b7018945a0b7fc00690ae6"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    sha256 "5f1cfe15cbb2b952baadcf8c11d3cc80ae9f62b061d93185a2c67829c66322bb" => :sierra
    sha256 "af99a9336d82d36e2f0a1b750295311dd032b76fe947c10a35a3f7755505e147" => :el_capitan
    sha256 "780333a9fd28b651c2fa0a4d25d72cd0c1b49decde32d0a063d3e86f8f9ce660" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
