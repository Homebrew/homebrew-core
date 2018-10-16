class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.17.1.tar.gz"
  sha256 "4503d2d0bf39af6c2c0c326612d1073d1b79668abe4090a2416a0cf7f325eff0"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08c5ece63d603e6df5d9af3bcede32c21a98501b2fb4c790d518e7d903e15cde" => :mojave
    sha256 "7c2e1dc3430885b3db41966b353ba2ca15f61a9f34b6fe19e31b70b210fc50fc" => :high_sierra
    sha256 "e3c21b7e24659b940673e5f725f8b3e0bff374b59dbee3e3d4e2898cc7c9dbca" => :sierra
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
