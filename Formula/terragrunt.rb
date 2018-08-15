class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.6.tar.gz"
  sha256 "6a9ee48d5e2897730eb17bffc96de0cbb5d6533f0c075a8a5b405d3d52ffcc14"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e57763a182e808566ca48576fc0feafa72455ba696c455609842528060e5d7f1" => :high_sierra
    sha256 "17cd3d16ea3a03b41a149048ee53d0fd60be975f0daea1159068e056cd513d62" => :sierra
    sha256 "61efd5394ffa9737f1f2475f7fb00bc54ae41394dbe54caa8d083ae44e1ed241" => :el_capitan
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
