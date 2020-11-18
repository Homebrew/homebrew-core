class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.26.4.tar.gz"
  sha256 "e342841755d32085b5c65d4f8c8cf9d068e96bd2164b7bebc2edcaa49e08d03c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "37ca99546dc141d4c662b9c2b00cc9423080398a24a6ad162e81ffe5fbf60656" => :big_sur
    sha256 "35981e3219ba04bb28113a2218465e4a087fc91d900a9a563548cad6b029a7ff" => :catalina
    sha256 "c9945d486aa9885c66ed720ac5471242fcdba99d51132f870e779187c6fb063a" => :mojave
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
