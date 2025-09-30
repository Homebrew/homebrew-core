class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "505721367958dcf86831e23b9c73b2fc4648a62be070e534abc82c71b714e7ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d405f3b7962c9b2d99292824dc71b75baa8bc9b873b34fbb08af1627176166c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d405f3b7962c9b2d99292824dc71b75baa8bc9b873b34fbb08af1627176166c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d405f3b7962c9b2d99292824dc71b75baa8bc9b873b34fbb08af1627176166c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7bdf2548074e3929280340b6972e8593a1dac468ac94de1a63c22e943bc2369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b895d062cacb011b964b3e17592bd72a42a15425f2776c0bd5362f10e4e26f"
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
