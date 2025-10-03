class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.8.4.tar.gz"
  sha256 "dc3335b1b070876f7b5fdf2093da63dd2ef90efe2fd340011e53aef33c33508a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86973d2f42ecd9003f0dfc0b8d3fd60c62dc06e77b5c0c2bc071f5a798d3f58e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0705706c82ab22bd723075c800f526642c7d356f96109051fe7c23ac0a297c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8204f96440b1cde1ad5a2450644a078a4eeca2536d6d2844ded8414e0ed8f70c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebf6d523563e3e7251a21d5048df7c2fe09b4dee4ca5fda8342f39fb5135c9d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40b4b124eb7130e877ccdb115ae0ed3be3a19c29d2e989f24762bf0a79be0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d32b1129e1758f990e8aaa22c6a027eb03f033a2d4cfcd0e8d7f570a63854558"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end
