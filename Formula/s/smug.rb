class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.18.tar.gz"
  sha256 "a7397f62415adc096afdbef87af297a7d1fd625a55abb9c5dac3bc39d1196d0d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1126306e80147d592efcf3b57ff610c40e8bbc02df3eeebf80206eb392551f3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1126306e80147d592efcf3b57ff610c40e8bbc02df3eeebf80206eb392551f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1126306e80147d592efcf3b57ff610c40e8bbc02df3eeebf80206eb392551f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3aae2c875a366eb6778d839a1a9951e324b77c1e670b52bda045b0e6a309fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e19a9160964769f02cac3d20edd653fbbde0e3d74fc6e322fb9d39d1b390bc15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8388b2211eb4bb3ec0668353d4005d84da74497827a5a155757d62e5df6f0f47"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    bash_completion.install "completion/smug.bash" => "smug"
    fish_completion.install "completion/smug.fish"
  end

  test do
    (testpath/".config/smug/test.yml").write <<~YAML
      session: homebrew-test-session
      root: .
      windows:
        - name: test
    YAML

    assert_equal(version, shell_output(bin/"smug").lines.first.split("Version").last.chomp)

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"smug", "start", "--file", testpath/".config/smug/test.yml", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "Starting a new session", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
