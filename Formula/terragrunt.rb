class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.8.1.tar.gz"
  sha256 "12c3e22c9541968ef001ca8a458af732ab38007aa5c5023b4229dde9bd2d4da5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    sha256 "ece4450c63b595c12213fa372ce2be5cc4108685adc72aa91c70925abef0069a" => :sierra
    sha256 "edbf691bda9e3ee0e97816d1ec638d8b1fd92ae25ee8d6dca26c86a2ad1c6ebd" => :el_capitan
    sha256 "774ca36eabcc47776b064f275cf7efe2e9d553de18af828fcd60abfa27e28884" => :yosemite
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
