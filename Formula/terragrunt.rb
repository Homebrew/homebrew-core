class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.7.tar.gz"
  sha256 "760738f6a8219fce2451c1590ed93e6f8cb1bfc9610893f82a988ecf1225a83a"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6303f8d4fead52841d317aa41c9d56d4029180a62e2489675e04ae1e20bc01b" => :high_sierra
    sha256 "01cd918c44a46c3ff05ba520c8a80da1da0dd4c62bbeb754ee77051e765283a0" => :sierra
    sha256 "b1c6b6d8c698ef3aebb60c11b4fd62a6fb25dc5928f5312cedeac97fd7bae881" => :el_capitan
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
