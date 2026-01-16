class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "40f9ab7d43fadf75abe7a4d71fac5ff083f71b63afada282146827725460d2d1"
  license "MIT"
  version_scheme 1
  head "https://github.com/thoughtworks/talisman.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d763005bb6e19df8cf0cdf814b2597f396e862c6f32ff6b066575164f9faa043"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c92711cc5d8857281b8bb8d7ba99f01b8389511e80ca0106cf2fbd9ab1d95e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92711cc5d8857281b8bb8d7ba99f01b8389511e80ca0106cf2fbd9ab1d95e19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c92711cc5d8857281b8bb8d7ba99f01b8389511e80ca0106cf2fbd9ab1d95e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "8918ff5adb067d32ec162569baf29e824d96b9f51e2a2c4a8dd118a8f3f02aca"
    sha256 cellar: :any_skip_relocation, ventura:       "8918ff5adb067d32ec162569baf29e824d96b9f51e2a2c4a8dd118a8f3f02aca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29eafe05ccc38bcc04e8c8f5669c9fc25b2a15c9781a72d0959710b41a96ecc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89549ecbadfe50fcce80851f3503243a9ea156a19561814ef73359fd44ea3abf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output("#{bin}/talisman --scan")
  end
end
