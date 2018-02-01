class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/releases/download/v0.14.0/terragrunt_darwin_amd64"
  version "0.14.0"
  sha256 "b2a7bdc05adaea23780634d9a48ad57872acb9022da5ae7ee7448ec3a6864fd9"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle :unneeded

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    if build.head?
      ENV["GOPATH"] = buildpath
      ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
      mkdir_p buildpath/"src/github.com/gruntwork-io/"
      ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
      system "glide", "install"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    else
      bin.install "terragrunt_darwin_amd64" => "terragrunt"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
