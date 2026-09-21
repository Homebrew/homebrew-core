class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "d1c43d84b5293cff1982437937367813f34cc1508d44da723b28649999147e3e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "28eb73930eb39cb973ba4d48f274142038da4c82e9b2016a0a53a5b4c188ef11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3108a8d3d4075c91b1e289ac91842eb371e06aca98866d7a40c7a9dfddf3f68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f3108a8d3d4075c91b1e289ac91842eb371e06aca98866d7a40c7a9dfddf3f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f3108a8d3d4075c91b1e289ac91842eb371e06aca98866d7a40c7a9dfddf3f68"
    sha256 cellar: :any_skip_relocation, sonoma:            "c12345af326cbd2946beaf28078797e092ecf31e553132619036cd0b74ac79a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac107433c2e386e98923c65c87ede7fb3af30117c90b084d3abeb0b327da186d"
    sha256 cellar: :any,                 x86_64_linux:      "646b1293932f9c237bedd5a20e9470d734ccbefdbe97de120f183b4ccecbd574"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

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
