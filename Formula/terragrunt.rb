class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.16.tar.gz"
  sha256 "2bf76d1662fabcefd963b6c86579203b0712ade88aa403a1d0da43ec057a75ac"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1372eeaac36ac656be4ae2cb790065da182cfb0fd5354b18d10db4501d91ebd" => :sierra
    sha256 "58a66e547a979dbd07f9b2a7995865ee187da2206d44991349ba97ba58849084" => :el_capitan
    sha256 "be2ba2111552a6bc8342d74165294d23398703308c3aa463b62c3234561e174c" => :yosemite
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
