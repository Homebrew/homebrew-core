class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.9.8.tar.gz"
  sha256 "fc5c71da1d12f47057b3e923d86aec64fb000b91e01193633451f52c12e74a6f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b838ef578e7815f25636dd1fbb90996f3d1b04752094169914b7b76465300f90" => :sierra
    sha256 "a88c07d2b4d3f6c90e3ec36ae01536244f4dde2c722b07ac530850bb0898b4e1" => :el_capitan
    sha256 "1ae60e8aa977e9fc66ad3f9b56afa7235fadffe30ea5f8564cb50da0452290dc" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
