class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.11.tar.gz"
  sha256 "56796a49f923f6df0dcc664ac65156e34107fdfde993f8eb4537b33684999257"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80cf33671a614e8ad01591b2ab902314df389969262ed06a9ef0115d4f519037" => :mojave
    sha256 "2f0912930e71ae9b6c54d31ff45623021527c9a0538249e1a1ebe507f62b7820" => :high_sierra
    sha256 "7d027fd14380991127e42b81371ff84c77d522a3928345d31c84e9bc81463dbf" => :sierra
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
