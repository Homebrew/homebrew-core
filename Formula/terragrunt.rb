class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.14.tar.gz"
  sha256 "6063ce9b28beb4e0c03e9f8a292fc6400c3aef4468741a146097c955be549e32"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b99fa9c7cea12b787e35b768fefc48876277aa209851a057c113d6937418d11" => :sierra
    sha256 "dc5d6d1566db37f093e9c744400ecc9b2bcc8e8d70cda1b56c02e3625c9e2457" => :el_capitan
    sha256 "695585a2a90b54f411b49af806142e0e9ff237ed9774f9f9c991e602f9debba7" => :yosemite
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
