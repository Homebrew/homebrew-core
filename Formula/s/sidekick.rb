class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "174224422622158ee78d423ac3c25bb9265914983a1f9b5b2e14543dcb0fe939"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06a9d456f48cc6f1bd81a60abb4878924af11eaaf9a1789d1f742152933148b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f5e190b61d1c87bb59f25cf984f5fdad673a7406eff0ccb3454bd68d0ce11ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f5e190b61d1c87bb59f25cf984f5fdad673a7406eff0ccb3454bd68d0ce11ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f5e190b61d1c87bb59f25cf984f5fdad673a7406eff0ccb3454bd68d0ce11ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d75fd55ec57420f0f8d4d769c8595427e2f93a6f826bfdbf5d96a144a90a41b6"
    sha256 cellar: :any_skip_relocation, ventura:       "d75fd55ec57420f0f8d4d769c8595427e2f93a6f826bfdbf5d96a144a90a41b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ca0bf33c36730419c4452ffb246562b00d594ee7e9ff677cd600dc587cb6392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30327aaf4244b393adc45eb87de8b24654c4ae8c7b837304f759b40df7c5045"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.com/mightymoud/sidekick/cmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sidekick", "completion")
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
