class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.5.tar.gz"
  sha256 "354cd6b15dbab83d807eec26fb70f5565925a13e30ebab9bac61004c041954d3"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45a11c5740564e2e47e6f571abab412354576472fbf9d4c1b7b5bf407398a91f" => :high_sierra
    sha256 "c6fea173fb6291ea94ba5b107ad7016c80941375ba6aef20e9464af64f41efcc" => :sierra
    sha256 "bb7985f7ba43a9eff83d03ba5871eb2522fce6d9b89dff0571ed52addb9ab184" => :el_capitan
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
