class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.13.18.tar.gz"
  sha256 "108786062158baa055b84d968c8eecb315442dae2df71086bcc665c4e469e065"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbe9d28f8ad3bb7a5a5735a1602c73b715511878a074aaf37250f6bd55db527e" => :high_sierra
    sha256 "fe85eaede31802386ef6104ce63d03567ebe8a48e1a366d8bc36d78fbf227bae" => :sierra
    sha256 "6e0e8d65047a7b166d593186f5bb309be4926791e9aee4eb7303b110ae6c3202" => :el_capitan
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
