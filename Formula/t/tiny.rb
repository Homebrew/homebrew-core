class Tiny < Formula
  desc "Terminal IRC client"
  homepage "https://github.com/osa1/tiny"
  url "https://github.com/osa1/tiny/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "599697fa736d7500b093566a32204691093bd16abd76f43a76b761487a7c584c"
  license "MIT"
  head "https://github.com/osa1/tiny.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6362dac49c5a0b79b04dc91ded217ab137a122398a14dce062179667802278e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "670eea450b4070a2eb2984d25773a284faf38671fbb333ad4d131cecaf23be18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56f21368dff225e7fae151b96ded515ab2c858c6a4cbd8bb5f124c6964937d98"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9c036c42cf375368d2668c63e52da17ffd3432f96729c41b685bcc0cfaeee87"
    sha256 cellar: :any_skip_relocation, ventura:       "7028b5c3c765572cf316d00e7fe552a37794e518e8cb0acaeb63c95eb8e90cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82dba4c308ec8fd1b7185f7a92427f69dae4ca52a2c503088e8d284dd3746e1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tiny")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tiny --version")

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"tiny", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "tiny couldn't find a config file", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
