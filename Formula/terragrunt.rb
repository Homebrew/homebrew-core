class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.3.0.tar.gz"
  sha256 "9369b133a3ce1d834a06d9aac45a611fb1290b2e1d893ff3d6c752332b5f5835"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28835356b4c3182eff157c38bf3f12fc162ab806630711b48f0d5a3df79c7db9" => :sierra
    sha256 "cee1b2811027f15d8780c3064c8ae85ee45696d0061d6a496c6abc5005464432" => :el_capitan
    sha256 "562d85fbb52151ad7be4a804efd0f48f64d2b305fa74768f7c22190e21ca9346" => :yosemite
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
