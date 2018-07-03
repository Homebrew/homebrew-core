class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.15.2.tar.gz"
  sha256 "fc84844e9e77e2882e3934d5dd535434cc38789d9767100be21454c997e38ed8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36d969612e5740781a7b6aa88a890a9be77d63e573958b4f71090b167cd67be4" => :high_sierra
    sha256 "29119cdda899c6e5f1a8b121f0b2bce6b9aae8ee2cbf6705e98252793810575e" => :sierra
    sha256 "bb5cad99911e164a11ecb91dedb56ac197fece3c064541de36cd42acdfa97b9d" => :el_capitan
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
