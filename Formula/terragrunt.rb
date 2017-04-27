class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.13.tar.gz"
  sha256 "6ce38b8119c935851b1d0585910a6b766185c7b05cfc507a58f1a5002f8d632f"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "338618cec30a132fa518f5b6aaf9eaaae783577125786550d02b9593de0c00b0" => :sierra
    sha256 "6c4a136e15db6222f575c143b264f65f19e2b3c76c94c2ac315b15d52ff7009d" => :el_capitan
    sha256 "4d27391aed015556e5447cd2d7506e6da032c1287ab1a1a120826586317f04fb" => :yosemite
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
