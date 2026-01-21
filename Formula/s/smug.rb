class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "d6592a91f8dedd83b286f6b95504ee160d387eef63a2fb2ceb84af6f7af3542d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10571660b89d7c7884c09384c9e4b7a0194db36258187592578c54c342ace4ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10571660b89d7c7884c09384c9e4b7a0194db36258187592578c54c342ace4ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10571660b89d7c7884c09384c9e4b7a0194db36258187592578c54c342ace4ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c875bbda25bc7b0b661a35c8597ab5dd16d124cf8402ca2cfd8f64d24de70b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b96e5e544f47c69af6a8c2c203ac720ccd346054e7befcd91c9acc2b6842ced9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2585f5816bc1f1eb282dea57afe6614180d62ef3497d45c2da4f6987575b0a17"
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
