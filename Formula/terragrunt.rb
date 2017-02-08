class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.9.9.tar.gz"
  sha256 "e5f6f01fcc0b3ffef3aefddcdada38afb064e6c128cef01a65f315cd1d6d0239"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "689a3eea1205b1fbd9a17f6875f057539718495d95d613c4bc5eba94c4a4f0ae" => :sierra
    sha256 "a9fd781f58530f27763c08fd58b1f03f543c0924b1b9e9ff7e3a5c703f0638ca" => :el_capitan
    sha256 "1a692a4a84d143841448831b945ffb90b5ad374963ef064368ab2d93fff762d7" => :yosemite
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
