class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.15.tar.gz"
  sha256 "03ab710f2af3f184b4cced09829c1667fe3eb9de7906f788a7ca78962e24f862"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4923a4f6a5db94bbf3f7ed125aae273191397863abda58fa7fb293e62a2463ec" => :sierra
    sha256 "a2a181a1c6af2f9307db0497f4e09e3bdfc1042ced22fd14bdc8586245ae91c1" => :el_capitan
    sha256 "9a2027aaf6242f8d47f70ba1fdd55eada67322125fb0f1b0ea3328ae1323ae2a" => :yosemite
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
