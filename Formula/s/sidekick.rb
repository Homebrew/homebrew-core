class Sidekick < Formula
  desc "Deploy applications to your VPS"
  homepage "https://github.com/MightyMoud/sidekick"
  url "https://github.com/MightyMoud/sidekick/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "174224422622158ee78d423ac3c25bb9265914983a1f9b5b2e14543dcb0fe939"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b47090a52636675f0dfae5f548f852059b7dc088872a2d8d64eec484e19db617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b47090a52636675f0dfae5f548f852059b7dc088872a2d8d64eec484e19db617"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b47090a52636675f0dfae5f548f852059b7dc088872a2d8d64eec484e19db617"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee43e780bc61973ce3d767a9685e535bda44b5fe2c92c0f387c1dc07b7b0dde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0fc03a04c528d79af849d0ca02d8b168f2ab860699d2d98e1c48a27642ff43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39755a46cd0a9f3fa863f933fc9fbf682d4e8841be7a882547fe6eaca455a089"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'github.com/mightymoud/sidekick/cmd.version=v#{version}'"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"sidekick", shell_parameter_format: :cobra)
  end

  test do
    assert_match "With sidekick you can deploy any number of applications to a single VPS",
                  shell_output(bin/"sidekick")
    assert_match("Sidekick config not found - Run sidekick init", shell_output("#{bin}/sidekick deploy", 1))
  end
end
