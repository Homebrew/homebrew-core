class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "cdd36271a849fc91d01f26a687255a1234056fbf3769facaf8ae36eacc4c1a4c"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6663d7a6090b4142b8c0e7d995b42e17f61d9ecc19b062b7bdf9cdd7f0bc5dab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfa2341cd25d68496e80bcef3297c9f9f4e236c36a25fd0ceed087defb00ee3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04c955249d9efc150bc8df96cd9e8a77946d3aae558a8038e9b4b7d249f46f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "d19398954753b4e4a59871320c10bd90ccbda8f22aa7400b0ad24923ceadd397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43bc0e2bcbdaa3aca5dd6eba17494d1e0f545f18840e1e492fc80a1f74e74bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb0184252c73fd0f36feb28327a76667ef55e8f2989af27d6166864e8b71766"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kriuchkov/tock/internal/adapters/cli.version=#{version}
      -X github.com/kriuchkov/tock/internal/adapters/cli.commit=#{tap.user}
      -X github.com/kriuchkov/tock/internal/adapters/cli.date=#{Date.today}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tock"

    generate_completions_from_executable(bin/"tock", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tock --version")
    assert_match "No currently running activities", shell_output("#{bin}/tock current")
  end
end
