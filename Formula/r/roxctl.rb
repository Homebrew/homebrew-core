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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69e73aa75e313f026691e668f045d9037b4f0b4093763a9dad7824d78a300f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4401cebf47ab6cf1b7111a115916afdbc220e075fc014efc04f7a2b5a37c57d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d331a50dc00a06f28cd24007e1055fcea4aea92f08cfe59bb4a0d19b7ae1fac"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce56a10cff72c085cfd0d2290c245cdbd2b5fbb6723bd0a45829e6fa3f354f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3a2d6e55588df0c5afdf8899cf201b3211f4a4da0a4f1eaec9ee2105c9630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b7be0848b8baf55a616e4ad9c6b5396864c8f07f13194f86979f8ae5d47314"
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
