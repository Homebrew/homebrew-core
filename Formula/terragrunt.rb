class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.8.1.tar.gz"
  sha256 "12c3e22c9541968ef001ca8a458af732ab38007aa5c5023b4229dde9bd2d4da5"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    sha256 "c12810273474f74cfe7e96c9cf78a9e172a000ce2c8b9cd9b00e9a26c9e6679d" => :sierra
    sha256 "2f1ca12d4c3db18da68986584ce3c547381e4b1bd7d0d7b0026aad09feb158c8" => :el_capitan
    sha256 "657fa4380b3fb92c70b08619fed3614dc78e8da590c2973cdbb00ba718e05fa3" => :yosemite
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
