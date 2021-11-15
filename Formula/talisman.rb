class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v1.23.0.tar.gz"
  sha256 "f6dc62887a869cb3c410ad5734febb2e084253338ea7470684795a20fe59bd33"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d09ea3f36c9588834631597f878c572090dc61c7a5c44494c07ae84e6c03d96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16039093a8a0c2aa5d1e841a25302f165cd59696bae453f851502802181e32ef"
    sha256 cellar: :any_skip_relocation, monterey:       "1db5541594b025f0f0699b6cbe85af28abd4a1765f1ad22f43312dc78ace969a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d5cc76c5262b203a6702dee85f0a3f9adf17ef1ad9c7c3744f4fcc0c22d3d89"
    sha256 cellar: :any_skip_relocation, catalina:       "dfcb3413f9259e82aef117ee043c0fbdffb92ff6f775482311bde77e9100a165"
    sha256 cellar: :any_skip_relocation, mojave:         "54bb2f487a4102c6cd2469baf52552b8ee44cafc9fb37f68227b1cd59ba98e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "418dd38c1543b59c1d71cd90c98c2f18a7f1aaa08dbbda7dabd0c3403b7cd4bf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin/"talisman --scan")
  end
end
