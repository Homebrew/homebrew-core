class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.11.tar.gz"
  sha256 "3e28311c682d613a49e0dd38b07c9002527f6b0b6cd0c01bac8bfe8d00ec6341"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00a6663bbab090b96fe0611a3dca73eba573b9e7474c241ac2c28e21d6f119c9" => :high_sierra
    sha256 "8084b13783499505ea01a592b6254062440c7f3c7d15e3c70022c6501d39ead3" => :sierra
    sha256 "f082e1b02c428218614387fb48f33bdfa24a51b9f9cf8bc5c5c16914549af867" => :el_capitan
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
