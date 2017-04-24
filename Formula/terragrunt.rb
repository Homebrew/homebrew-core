class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.8.tar.gz"
  sha256 "6a188f8f87964c99e2a4c1aa3b9292f280b9a44ba4de5250d3484e50c30baccc"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48fbcbabfd0de38ac1917195f0e8001811636e1d759f7296abface6734525571" => :sierra
    sha256 "fbcfa662ed2f0c853cf38a9b8da11e3c75e36928c963a2e306f49f28bc0d6b56" => :el_capitan
    sha256 "8555a3d151047bcd10cb9e39d729f4bd3c33110b37af324b6183cac27700f200" => :yosemite
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
