class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.19.tar.gz"
  sha256 "59e5834c436b5b69f21523f43156790311b1fe1cf810ef0b0d422079249104f3"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3964ced7429d23e3e2106828a29bbd20c6d3c991a3e5a5b686a02138b5ecb01" => :high_sierra
    sha256 "81d0553a5481bcd10ecc733c252cb1c8aa0067bb65e1e578657495beb260e279" => :sierra
    sha256 "ca7c1b11c0f9276c80fa71295e9a2e4b61003687ea76a5cfc18617d3d8416080" => :el_capitan
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
