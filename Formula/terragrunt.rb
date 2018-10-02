class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.14.tar.gz"
  sha256 "903efa2c86fb005d6323abe02d791623f90c75cec12105148d8311ec99de4645"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b94f13eb13b0ecdbae6a2ae4685ac4a15eb87573db20ab58ac3b4a466f5d6a78" => :mojave
    sha256 "f7cc8c3826f624b5ebc82cd6a3d3c5bf69de4b82a7924ac60fd8243cf99c5c24" => :high_sierra
    sha256 "f2e05422fcf66134fa785d796b4f77903494776d06f793c5a7ae2fdf90d3cfde" => :sierra
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
