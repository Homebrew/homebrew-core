class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "0664661250ca675f4bc709787817b53759d7b20ecc87e6b01b5f13002d653797"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5f45667e3e7a430656241eb38b85cd3d25a8d13159a806b3477148e75cd9c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f45667e3e7a430656241eb38b85cd3d25a8d13159a806b3477148e75cd9c32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5f45667e3e7a430656241eb38b85cd3d25a8d13159a806b3477148e75cd9c32"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2615272e49b0c311b196b597bbf9681283b2120931d29292ee38f58cd053e6"
    sha256 cellar: :any_skip_relocation, ventura:       "da2615272e49b0c311b196b597bbf9681283b2120931d29292ee38f58cd053e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "262cd8d04d0628dcf493599c3301cf7eafd462a65f030683da7867a1ed7dc208"
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
