class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.26.7.tar.gz"
  sha256 "4188a625c7029c340ee3b5cb224c6573f95dc01e8db42b6ff456abd0087336df"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "856c268bc112793d36597723fbfe47f85a7a5c71a45fd1fe3e622249cfb8a837" => :big_sur
    sha256 "007ff55a357135b5080643d2bb822bf5fa1ee041e057258914339a2c9ada67fb" => :catalina
    sha256 "ea395457c6d586148fbca7e0b06d18e148e7b9efab7df35c2c432e43352c34b3" => :mojave
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
