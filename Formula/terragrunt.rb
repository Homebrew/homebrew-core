class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.0.tar.gz"
  sha256 "222a6397913cff5c5c66fdbdef4d4c19f707a8eac1d285a20087e3002d97f33f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bfaadcdd09dea3f3423904eb30cb45584d5c0acd11754b5ef5abf7187a4d040" => :high_sierra
    sha256 "eda7d7e0ff5cc8082b2700d4f259a2930ca99bf51194289a8fb00c615cbf1f5f" => :sierra
    sha256 "46712a10350585195c2425e41a982f9c5181e257b33083e30491481cbb3e55aa" => :el_capitan
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
