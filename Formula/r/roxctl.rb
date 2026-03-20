class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://github.com/stackrox/stackrox/archive/refs/tags/4.10.0.tar.gz"
  sha256 "859b52c9193942fcc55c3e83170765ca21843a0c33071dd9e924630d023ef353"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5af6316a5661f1ee34dca21c17d961806eed69cccdc1a1766dd959a074d74fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68759f77e8d18f9173b29751d912b7476235d35ed5286a2fc7cd050b83072c0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eb800d2d43f969513b2cf37f3927a8b703210c8dd2c7f398292a8e0c2beaa5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7368b968824bb43eca4442b21572dfd99c41d93e865268706491e43b594230f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fde6de66deddc6a9e41ace3608989452ea8b27291d1ef273afd0f38c7950442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c47d13b2545c582c0aeb61f7198988cab7544902d587eb3ef5dbcc246db0fdf"
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
