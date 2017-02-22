class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.10.3.tar.gz"
  sha256 "49465b02e3269808241a3411beba6bfbec0e49da08170998531598b8f99a8ab8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8530157d9ad6da34fce0124fb2e9f5a21ce0a9d3dc37648680d6580bbabe224" => :sierra
    sha256 "f1f8dbd5ac24090240780153a4672e25d463dd469331263e1e11fa5815928a82" => :el_capitan
    sha256 "e41ba8d64b6ff3676023f789d9f915093e9247a6adeadc7690f710bf05b67544" => :yosemite
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
