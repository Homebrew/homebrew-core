class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.11.0.tar.gz"
  sha256 "847fb1c8522bc3eb25248f3f626946a7e5d3d1ec79c809952ccbe5441c9ce593"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4d402df8afca34e4f2fcb8c5e34051fad1e9077b254da43d4434d500554f183" => :sierra
    sha256 "3a27080e321c798100e4d38afc27ec16b7ec24070fc758a7a9dcd9c423c79b85" => :el_capitan
    sha256 "6eb9a7cbd0071d1054f2f6bf89c5caa4fabe63196781738d85d28b4f02fd0563" => :yosemite
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
