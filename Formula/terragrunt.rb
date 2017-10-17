class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.8.tar.gz"
  sha256 "6ad9d21dd6958ef678e854341c7c95100dd7e945ef3bbddab02b05d1bf3c427e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d943ea7f5b60f551f699daea0f4d41bcd5995168930b0f6fcdc4f8bb6212deb5" => :high_sierra
    sha256 "a26b818aecd8633e5b77eb6ba070856676b6f133ea3151428fec635d39b5ee17" => :sierra
    sha256 "d100dfdf9bc967b1a4c931918e10b1b0e4ba0a67736cdd933f91c92a19bc9c5c" => :el_capitan
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
