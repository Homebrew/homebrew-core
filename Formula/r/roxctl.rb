class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.9.3.tar.gz"
  sha256 "739523a88f936146b078850f92590dd2b6c99b3b79973d679a8ff0bb25a12ffe"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  # Upstream maintains multiple major/minor versions and the "latest" release
  # may be for a lower version, so we have to check multiple releases to
  # identify the highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8a8a50740f0b054796e1b257ee2fe4441c8dd1c8bce3d9bb89320752672d60e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "316f5395abe95e8ae3c06182e2bc2ed3c18afb7dfbcb6db52f778e8d5273c3b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d599ad7247db31f1854cd4819c01c2ce5ece7f79157af8359140e5dc8a874403"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ec35afa22f9d5697b98186faf32147b2c5a6f8f8e4e449855db0a18b6b8ef90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6d99dc8e440ef59b25c272a79dc41d83c0d1c139a7bf43aee03390ccf4ec3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3111cf24cc20772e6812a91ea5ec3737057c13add47fc70688a2f8897acb443f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)

    assert_match "please run \"roxctl central login\" to obtain credentials", output
  end
end
