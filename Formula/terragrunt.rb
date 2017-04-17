class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.11.1.tar.gz"
  sha256 "997276ea4c42d541b570f72a3e69bf2e889382b54f9c1cf38b337ec9ec0553f5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "486ecb40c9cf8d33992a5ed33e32dedbadec9f3b9329465a9422c2a1687459e4" => :sierra
    sha256 "3d21b2ae76fd560dc6a3eea4b5002a971c0e496cc64c449ebfe05299e4f7f9ee" => :el_capitan
    sha256 "3e88553f3ea6b07162bd3b16bf17409d048f974e2615fc72f5ea9c1243b49ea0" => :yosemite
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
