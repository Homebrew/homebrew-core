class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.15.0.tar.gz"
  sha256 "6e8f033357492f8c397550e19aad55b8167a10b309448b12f02b50b8842a30b9"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85dfcb23fa4d3a9a675ae248e19b0831b9665429d768f0de96472f63dce78f1f" => :high_sierra
    sha256 "ff15a234348896b2ee3269a3230590203224dd8611b4a495b97a11115b92f36c" => :sierra
    sha256 "727d882e505dc4072fc0f00eba4a3061b79e4dfe89e227a7823d7223255f333a" => :el_capitan
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
