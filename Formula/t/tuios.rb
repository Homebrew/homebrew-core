class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "a803c947890abf8f82f77f287eabe360d4f4aa25dc13059d4264d626a9771daf"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64de122fd3127a0c83185f1e4d66f8f29717df289b375eb5e58ceeb46e5c5297"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba44afb9329f08a48807655cbedb099615ccf7068729feea99400bd970c75da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e8b027f0a14dc0c07b5da368c8101f2feda3933f75fc6d8ddcf5407f466f1e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdd115292259ce60ace88523e0af90a1ede5545524f2cd564336f3236583bf5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc8991b8b7e057b2874b2f7aafe56a953dd5c7b9989d44e7cdc2c0a9f1c9b921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa59980e2b355dfb71c4c2f060e3ac268af74eaaec4da253ac65f1d0702ffd01"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
