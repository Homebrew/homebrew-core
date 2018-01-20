class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.25.tar.gz"
  sha256 "de7f0288e14c9de0ba66c92379ee37315a521642556bf0feaef91972663fb230"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8b9e982a0c626c303f139dd8ba5acf72f8d29a2289040cd6e471b2be187dfb9" => :high_sierra
    sha256 "f00e8ded845c19e8f97088ff2e9e4609df01686c01d3d75682139c3440c33d0f" => :sierra
    sha256 "b2ff50dcb97c7892239da99194fef322c68b71b314c9a476e597d0b50e55aeea" => :el_capitan
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
