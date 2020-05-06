class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.23.14",
    :revision => "a316898e9043efe4d5333efeeee941a16a738608"

  bottle do
    cellar :any_skip_relocation
    sha256 "15936c695bf43cdefd4e9eb5b5d1b90783e0385227cd642981bd24a1c55a7295" => :catalina
    sha256 "b5a96836bc02cef333ec099480b25139a6d98301c2381fa7648900768e755f47" => :mojave
    sha256 "f3d46d0af99835f1425353fd273b74c02bae7ba355509fbfb70d5628795f03cd" => :high_sierra
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
