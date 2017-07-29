class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.25.tar.gz"
  sha256 "163c38465c36301b875155fc78f964285862083f54c7cef0fb618484e0bc83f4"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7345ca549fce53369cc642b4f454c7a37d52a025df24e26d5ab6f5bb6e094058" => :sierra
    sha256 "08ec7e5bf922775a9079b2aa3f0cba5ad4a08d8489436617913cbee172072f0c" => :el_capitan
    sha256 "354858302d40b93ec9ca5bae071735c583887e4193ebc4a591f3effd944234f6" => :yosemite
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
