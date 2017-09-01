class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.1.tar.gz"
  sha256 "0d15df6f327335cd68464b71acacc5a6d2b82c62d6b63d019091338ed9219a97"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9def5272e7472c4527ecea0c9ad92d927c6831959c794a39ad4db20a41acf82c" => :sierra
    sha256 "62ed4ea2d0002470c0bc9fc39a9b4ac32cb954aa2ecb4d9529e16289500aec44" => :el_capitan
    sha256 "319d4a2c295048c0a1dc21d0efcf15c9c57101af2ebc2b407ecd1c1f260510a2" => :yosemite
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
