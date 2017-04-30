class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.15.tar.gz"
  sha256 "03ab710f2af3f184b4cced09829c1667fe3eb9de7906f788a7ca78962e24f862"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9edfca06dd24877a56e0e6425fdd7ed944176d0ed085bde8aefb562bdbe1fa97" => :sierra
    sha256 "78f318dbd6342cc84f56f6d4d7b6a0e36888a84b81b7abaf81888ac4f10ddd75" => :el_capitan
    sha256 "897b564714b51c5b43ef582dbfc69b9cfed83668a7577804728a1d1c2cecc481" => :yosemite
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
