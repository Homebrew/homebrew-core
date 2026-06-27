class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.11.0.tar.gz"
  sha256 "23cd60a835019c66c5742771e2566a47dc47858a7a59841e7efdf12a664aeae5"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13fa74d09ccf998bbbe7b7a19ae7fef6bf27ed23d0963ab84f59db4e495cc6af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e6f56abcd06d7c6d8588ff0ad3351827c079cfacbb72876f642628662a71271"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0b612df6d326800b2b945571fc2a27491930ccdc68743e3d3fdebb6f0989675"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd81a9a23846b4502b65920c1b72e5eac5674883126ed780d31ffa3690d517dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41e1ce36d1856be61de2f8734699739e2cdbe59332a57c66adef46a42b9dafb8"
    sha256 cellar: :any,                 x86_64_linux:  "20f47b837bcd9f48b0b9689248b7fa41db27b6d648187a90f682f8d207eb9ee3"
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
