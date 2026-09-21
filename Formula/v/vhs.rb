class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "2e4a3b940f66ffbe1f66ded3b6253c9f3185a69567596e80d08c50cee77eaedf"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "818615eb8c161a288a8736e4530302a8a0b3a8e330610c750225fe5ea9a62f8a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f4b297f4bbe869b45924b4e4ac84b1c4ba7db1fd5b1560e61abec5defacd21d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7f4b297f4bbe869b45924b4e4ac84b1c4ba7db1fd5b1560e61abec5defacd21d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7f4b297f4bbe869b45924b4e4ac84b1c4ba7db1fd5b1560e61abec5defacd21d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ceed6691fb055502effb55a5581ec0e6ffc6f0f0d999b2405b6ddc5e16595710"
    sha256 cellar: :any,                 x86_64_linux:      "8544900316bc04ea71601dbdf463363bd8f03a7ad73d2815ef56789c6e40e0e4"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.tape").write <<~TAPE
      Output test.gif
      Type "Foo Bar"
      Enter
      Sleep 1s
    TAPE

    system bin/"vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
