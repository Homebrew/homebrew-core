class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.14.7.tar.gz"
  sha256 "9f2152746924c5591618ffdb02387b706328267438cb504e91e4e86fbecb2863"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "218d8f500410971cf5116cb4987870b482778668f39ccf7b08751036bffa99cd" => :high_sierra
    sha256 "801cdaf4aee96da6045eefdcf02eb53f48a1e58a09f3d6c542e4729ce7537bac" => :sierra
    sha256 "d7f71f585cdb572444fa9b47e4968c6d1ed4f842d8a06d411cf6da8c0b7eb17d" => :el_capitan
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
