class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.2.tar.gz"
  sha256 "408e235c4f8ea24ed227d5f254ba107be60c80ac6a2d54aad46053174b1cf0dc"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d94beeeadc040eaaefefbf7d4f075dbb3776d7aa2ff69b76fa3752dc3a0cc8ab" => :sierra
    sha256 "77206ec14ada82f4c4f2c9295186f180781cb101880b02793ed709d021cf27c0" => :el_capitan
    sha256 "bdd883f575e88a8b82fb30e4135b9365f0b4c0331bf426941af103c281544cfa" => :yosemite
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
