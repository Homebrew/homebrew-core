class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.2.tar.gz"
  sha256 "2507fba27dcb5bec9e342cfc951e3696fd1f84a0cff0b98f3745f33157f03bbd"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d8d803b43876be64a84be5e7db4657fc77b7a5169ec46538e72640a4a63c9d5" => :high_sierra
    sha256 "be6772a2aa91dd4f426a382e07ca3cf3bbc1503c90fcbe620eca4e605a7bea6f" => :sierra
    sha256 "1676513edabd0cb9e444f5723faf63ae0ed119d1202b6df43d85a2850bd0c31e" => :el_capitan
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
