class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.12.tar.gz"
  sha256 "751b58ecaba6732d9dabf9216dff69d42086310bc7c8fe8d5f80d72895e6d1a6"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "380971c2f0fd1603c651d42278c63f0318d62fa3d773cd7fb97484b833ecac9e" => :sierra
    sha256 "bcea3d94b61defc85765c49058b9538a0d927cee6fdff5b66dd15565e48edbc1" => :el_capitan
    sha256 "766a67b8a707d42258d64382d8bb93c25f02db10154d596c97b23d9773f2b3f2" => :yosemite
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
