class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.9.tar.gz"
  sha256 "24eb85840cd88379b2d95f64d2270b61b1632ce47a967f507f865a4b12796bb4"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7bc8d5ca0e24c17cffadd2f538160ef3a4ad9e5d817de39da9ace014c654c64" => :high_sierra
    sha256 "1c356363a8465c87692fcd66d1017edb7510ff137da43231ef462813cb07481e" => :sierra
    sha256 "cf0015931139532f98dc3c96df2757ce859bfa66b9932572f301aa28de310221" => :el_capitan
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
