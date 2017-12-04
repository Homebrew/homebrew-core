class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.23.tar.gz"
  sha256 "84289ae6b93281cb9f6bfddba4ec305384eeaf63596445375ed25dd024398e7e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62502105ea3d80508bde7fc001b4968a2c402341e22e18fc3ce05ba961a9eaae" => :high_sierra
    sha256 "a1f235d4fb78802c7b2e3a91cca04edc012641e2e4f49f468c458e7eb9ecf6ed" => :sierra
    sha256 "f5f4e6c1df928a89443a2265b2fadee433dbdcad8521046a066bb73343a2f6d2" => :el_capitan
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
