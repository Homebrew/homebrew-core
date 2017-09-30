class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.5.tar.gz"
  sha256 "0987cb163dc2be91fe8eb7cd4c1449974008837e18d42ca1845f538fa77b4997"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f074b3b8c0e90622cba53c844abbd5f4cb12f06eefb8ac6cc1b3fad43562b2a6" => :high_sierra
    sha256 "9438610b09e24bc29575f71448530cd4629b0aeb474f04a018774e04ccaa5d80" => :sierra
    sha256 "77afdd7905c9286381531981904fe1fe89967cf1de290837051a05c73c5e3223" => :el_capitan
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
