class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.17.tar.gz"
  sha256 "cc221198c31ac70c633dd14a6de0845f100c4b3fae00d0a1cd9e734b47f7f560"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd2243aabd04e24c7385426a57a06aa235974699094a12a5f62719046ccdcbef" => :sierra
    sha256 "25e49320077e88428d008d3e710432a8acf050811a47a8e80dd51b83cb6eb41f" => :el_capitan
    sha256 "88b0b652b6d53661886a72fbbb0e07821ffc15ecf80bd867f447d6ff33c1eb47" => :yosemite
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
