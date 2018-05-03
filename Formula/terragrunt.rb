class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.9.tar.gz"
  sha256 "4655bd4d9d64ab36325680edbd0fc990f8db715f6835f5bb8ebaa4ee7df0e858"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e75534b040c4e9372683acfafa475c17d10ae46ec2d130c347e46066d26aa5f6" => :high_sierra
    sha256 "bc3818c4cde28e9d17414d76cf34f16415063f9882b848694942262d250a80aa" => :sierra
    sha256 "c7ffd43726a404d79dfeddb2b924ea56ad317dddbed3b838b8a6d28b91bedbdb" => :el_capitan
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
