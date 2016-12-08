class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.6.1.tar.gz"
  sha256 "ed8ad95140d5b99fdb31c0db65e1ee6ba6345f91b4bda34757d80924b68850d2"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b19d7a65f9a73a4c373d6291106c5cc024c0a3daa1c3270704f7278502b5cf7" => :sierra
    sha256 "b44d1df2e9bc4432dcae5cb30c396c7a85d2372db0374036cc420f6089e58a6e" => :el_capitan
    sha256 "08b2495fbc05b7c33a5e2c1c0cf4b9cd8d0b08acfd4ecf17c4236fbffcbcd2d1" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
