class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.95.2.tar.gz"
  sha256 "96782b2205c412ce0fcdf2538ddeac166a86c1ed907bebb5991b5dcb65c3e34a"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a56360b8ce6cf004f7893de031f066ff1124ade7387722819e98932d7e09f777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1011dd5e87d8c828c44f7d73906d22069d26923c3035e841f5797672cf7aaca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "638f205af87dcc6b2752c403d01e82fc5a8dd8b3681439af4272824718eafaf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fbb6e6d1987c49b6fcad02a683a995bdb30af361c7871e5dd3c35bae70c592a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfd6cf4f53b5c72da60a2ff032b9b98cf442347b533fabcefd808ddb6bb7f4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32f2af9f5987a4d3ce84b07a929be27d801b65727a848647f3c73a99034aa403"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/man/trufflehog.1"
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
