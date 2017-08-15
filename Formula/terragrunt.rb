class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.0.tar.gz"
  sha256 "6286657a3f821919122e6eb7aef50f6cdd37aca669ca30d0bbae14a790651bae"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8e247684b9a028a51ee9b3f1e1ebfebc738992cab49ddcc057d597198695003" => :sierra
    sha256 "42080e6b64a21524b89e198e84673ae01419e0a41a20b31d979ec086f52d36f3" => :el_capitan
    sha256 "35d9ee2babbf94faeae4ed9a55e029f47ce0b32aa15dae7d64198a1114effd16" => :yosemite
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
