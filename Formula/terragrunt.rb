class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.14.tar.gz"
  sha256 "6908826d0e21412e8b863edd073bfbdcd1ab96339dc621249acef96133760e8b"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33b115062e9f2114d0e80f43db5e125e49b1d07fb2780bdb69d94a1bce768c26" => :high_sierra
    sha256 "09b5a2ceb39ecf370c9b621494d658be3120b3dc23979dc083392a0bb839d6c2" => :sierra
    sha256 "5e5e981e1b05fc039a16a892768ce63d322ce9515565f218e5f5aa5022c1c095" => :el_capitan
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
