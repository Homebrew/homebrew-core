class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a34abfd522fd5ed5e82e172aad0de2522662b23ba9bf769d1205cd80c50740a4"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "186c65069d7a43cb32cdd4b39bf7047b8563e2e2637fa0f001ae349658fbc58c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61686f87fb070c50b2a3cf4fc5773c27be04c84de1833a65078c4c68221bc77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1e5fd98cea5c655e379235d169243fe172a1f95a0b39edc51c751af2fbd768f"
    sha256 cellar: :any_skip_relocation, sonoma:        "50fe12a80150e8e820bf3daa680a3ffa6616151444c667b497e55e98cc6a0d47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66edcc1d309640591c42b1a135e7a6b94ee6697a988648a566a6525f396e644e"
    sha256 cellar: :any,                 x86_64_linux:  "775d26f5124075df0c75310a8481230630067b9d60a3dc0d6c39c463355a0442"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/app/commands.version=#{version}
      -X github.com/kriuchkov/tock/internal/app/commands.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/app/commands.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
