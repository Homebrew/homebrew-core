class WormholeWilliam < Formula
  desc "End-to-end encrypted file transfer"
  homepage "https://github.com/psanford/wormhole-william"
  url "https://github.com/psanford/wormhole-william/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "a335d2f338ef61ee4bb12ce9adc5ab57652ca32e7ef05bfecaf0a0003b418854"
  license "MIT"
  head "https://github.com/psanford/wormhole-william.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95c69d404efc9bb7b9711c6aa10ffdab4200b5b9907dbd0f2d40d62d405fd7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a2dc8b4b71e6dbabc0ee97d41fb611cd3e4cc6535e31945ccfc33aa4199b341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "477dbe264a083cb10887a36ae9e67d0166f9f75325eaaea8c45dd3dfdfde23ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fe6a0d302cd5512995bd744396f842d6a299cd8b3dcb63e5f368e135ffa6163"
    sha256 cellar: :any_skip_relocation, ventura:        "e362bb428a4492ff714366400332442ff5c88e7a11e07a75001794722b5a0fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "52d8b9842020611e9db8912e7bac22ad8cfe5a6c8f7b82e812caf54166ab8f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4034ed2d1c3ca1dcb1fc521706627804c67aead24430a253fbef4218996f2b9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wormhole-william", "shell-completion")
  end

  test do
    # Send "foo" over the wire
    code = "#{rand(1e12)}-test"
    pid = fork do
      exec "#{bin}/wormhole-william", "send", "--code", code, "--text", "foo"
    end

    # Give it some time
    sleep 2

    # Receive the text back
    assert_match "foo\n", shell_output("#{bin}/wormhole-william receive #{code}")
  ensure
    Process.wait(pid)
  end
end
