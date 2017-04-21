class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.2.tar.gz"
  sha256 "a253aa69dc491997b8dad21177bd113d60398feffa7490cc7e09fb6ece5de88c"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2da4d72da423c27838d789d66ec3da47335424510df5953278b8953010942865" => :sierra
    sha256 "b5ebc1690ffdc14333cf8744f8ab2150e111ebd1f5f7bf137c169edbf2742046" => :el_capitan
    sha256 "bf766e816f1eaf3c80fdf55838262ab2227bfdca18bf7fb4ce5bd185b1e7ff92" => :yosemite
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
