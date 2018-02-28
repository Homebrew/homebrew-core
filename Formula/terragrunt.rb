class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.2.tar.gz"
  sha256 "906d13a8d0bc9c6cb48ad7f2e0735c3e3cf2663bc38b5175260321951e0b6041"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d28184c3d767c2712f59c1b2cf89e2df2dba833027b5578c6ec9c9af06a8431c" => :high_sierra
    sha256 "c0e12da3c38fc95209bf3e1b41bf4c14855b746c68b0954cef8c4b3737d8b8b5" => :sierra
    sha256 "366bfc2683028eb16023928a6b543adebd2ef0ffecf9421e01f2713ce084b3a7" => :el_capitan
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
