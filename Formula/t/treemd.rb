class Treemd < Formula
  desc "TUI and CLI dual pane markdown viewer"
  homepage "https://github.com/epistates/treemd"
  url "https://github.com/Epistates/treemd/archive/refs/tags/v0.5.12.tar.gz"
  sha256 "e786ecea7eb7b2fbac9d71cefcb4ffb5170f961fc45e530a78a51122f6ca4cdc"
  license "MIT"
  head "https://github.com/epistates/treemd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab3035efc000879d106a7a9900bce783cf5cba90dfaadd9eac7565931b623387"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a923d11229f1050d58dd60be25ffbc02c109ef8e82315f8ddb39690466a7053"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2d14bff93bc4285c0f6c5320bcd8661674a4cb9dcc247c9ac7c87e3c39f2d93"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f96b716bf99dc6481b99166358876de653379dc440ccebfcd6f022f2f52c418"
    sha256 cellar: :any,                 arm64_linux:   "25fd4a11bbe0b4d73c40b45d09c5c3a1eb1f7acd578087de365f2d512333c14e"
    sha256 cellar: :any,                 x86_64_linux:  "5b28ba95dcf7bc8ee5381b9600cf096f541f4bf9fd56c5adec1bcced4efe204d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treemd --version")

    (testpath/"test.md").write("# Test Heading\n\nThis is a test paragraph.")

    begin
      output_log = testpath/"output.log"
      if OS.mac?
        pid = spawn bin/"treemd", testpath/"test.md", [:out, :err] => output_log.to_s
      else
        require "pty"
        r, _w, pid = PTY.spawn("#{bin}/treemd #{testpath}/test.md > #{output_log}")
        r.winsize = [80, 43]
      end
      sleep 3
      assert_match "treemd - test.md - 1 headings", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
