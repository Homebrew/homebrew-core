class Smug < Formula
  desc "Automate your tmux workflow"
  homepage "https://github.com/ivaaaan/smug"
  url "https://github.com/ivaaaan/smug/archive/refs/tags/v0.3.17.tar.gz"
  sha256 "9956b457b2cb6444844e1249aba49819d943663784953c9e1afd32c29acbc7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d28d8625885758a49473fa57d55727f3e28e19f399665fd23d861408bd88ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5d28d8625885758a49473fa57d55727f3e28e19f399665fd23d861408bd88ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5d28d8625885758a49473fa57d55727f3e28e19f399665fd23d861408bd88ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd25986b3087e0709b4ce46ed8173b78cc3e64c82a95744fcf5e5f8d3d7227d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ad223a17e1d55f9d4110162ac9c92d72f7a02dd17190100a7db61cc57a5736f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0513b7c205b7126c09ceb741ad7f723820655c25c4fb57a6173a3429ded2d9a0"
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
