class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.9.8.tar.gz"
  sha256 "fc5c71da1d12f47057b3e923d86aec64fb000b91e01193633451f52c12e74a6f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    sha256 "840775894fc26ec1e037b4f425a0ec7daadb2e0f1fd5b394970534f2cbc44763" => :sierra
    sha256 "59b06d22936d4488495bd715c09cc890ab793550b7984f19cd3353f8fdca8fe7" => :el_capitan
    sha256 "8fb4885b234df017bba1f241634bf3deb2a2d5faef45aed400944a69a56bd397" => :yosemite
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
