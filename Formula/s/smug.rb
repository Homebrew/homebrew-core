class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "99bb8f106d7c8b0d4afd38462bb4201ac1456bfd61173950392dfe68337977d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26e3e6050803b01748b024d6576def644d7b354aa5f4451a93f2cf6d288058d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26e3e6050803b01748b024d6576def644d7b354aa5f4451a93f2cf6d288058d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26e3e6050803b01748b024d6576def644d7b354aa5f4451a93f2cf6d288058d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28d1c305692420097f190b0f88759b11b969c665419a6279a4954b4cb3d743f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee3693c36f129d15246d3ba151bf05292a89ee5437498d5e2dd377c23d8d58ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42906e8306e24eea4bd1bc1a58d4e63026a48227c9adce198faaccb0abb4f7ad"
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
