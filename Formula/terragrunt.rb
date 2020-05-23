class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.20",
    :revision => "0ef5a28a63494768c60f4eeada6185949c6636a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3387016a9cbdaacf93cfc8d5a7651d5f0d5fb16a75a29221710ea2b96abcd0e" => :catalina
    sha256 "90803d4576d0c7cacbea4b6d917c3fa49918b2c1372affd403fb9726dd643553" => :mojave
    sha256 "f3c5a664d8f63df49563c5d065ab09076eb0a62b1b096a95d161c4c5a2e09619" => :high_sierra
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
