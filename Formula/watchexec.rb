class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.17.0.tar.gz"
  sha256 "efcb6027a0063cd57cba41553511ccb2c66cc79d8623d430ff276ce506aa96ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "abb7699f530ec734c1335fe284e36c33cb60feb9db3e5af234303761ba7bad67"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3cd2c7cc38113ffce6ffbc529936b7c1445f6ac4137690fb490da2ffda55745"
    sha256 cellar: :any_skip_relocation, catalina:      "30e005514bea634a0e0e446e9406e67dc089af202c24ba8f7600530cef260a52"
    sha256 cellar: :any_skip_relocation, mojave:        "733a21641f453b071e7a9271bb0ba0994fc95bb898bf7aed535d645441916431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac89d5befea2c723f0a8af6bd14a8a0c2f9d9ded54d478ad2c68bd600b0b3d5a"
  end

  depends_on "rust" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
