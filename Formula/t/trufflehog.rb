class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.68.5.tar.gz"
  sha256 "23c6b4db6afce42a44e3443c137b658610da9ec1c7259c42f602c2eca9816bd1"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e60772da4b83e0caee0fce4deb754948f00115340632345553cddab8899a13b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c2326a15c2f78715252949022ac860f3b2d2bb3449d9d068f6d472e89696bb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "689d456998abf935a514ee1ea59007ebe53f84b0268bf86bd799ba764fa0cddf"
    sha256 cellar: :any_skip_relocation, sonoma:         "89554b5b3cfb04d409e83611aeb45e6b61abb3f93c04423571c18cef1d1087d2"
    sha256 cellar: :any_skip_relocation, ventura:        "fe64c088972b6b6fdcfc2d781d900634e59ec30ea6863645e735953edd1ba4bd"
    sha256 cellar: :any_skip_relocation, monterey:       "d791ea2f86b1341f0652be365dadb2df7227b601ae39effea96203378d5b207d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3525530a73fa4fa88799e5a4616d5d140ff26297e1c2658b3f0fb655ca8b8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
