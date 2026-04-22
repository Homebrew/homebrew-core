class Tock < Formula
  desc "Powerful time tracking tool for the command-line"
  homepage "https://github.com/kriuchkov/tock"
  url "https://github.com/kriuchkov/tock/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "39d05e549b18f06694e313a1eea91f23b18a0d1ccb14b743302e200908102183"
  license "GPL-3.0-or-later"
  head "https://github.com/kriuchkov/tock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a5a8058bf2efd45b47b885e44e3d15342623779caba79e1f7451bff45229a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "788d3f31ec99c08680d2a82014df4c489c0b8112a4de90cdda25b6789ab8c8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f69f583e4366b0dc2caf8786d6f539fbadc299262a26a358f226214d052e5741"
    sha256 cellar: :any_skip_relocation, sonoma:        "788d909f528885461355cffe38236c4e87591d5da58358a68bae87af68a05e0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d35d3b4aa3d21ec9c94f065b7a03350dd16793a29171270c6817542cd660ce5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e252f509b5ba67ff2331fbb56cafa562a40e6988957dd0d0544854e61548bc"
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
