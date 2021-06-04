class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.16.1.tar.gz"
  sha256 "d8e8e5ef6c11f4a7512f4841eff8960558edb39f54a563e5dda8e1058ff057b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d595eb504c88c0105e641f6a3a984d4b3244da2f48f724cedf127ada1b7c109"
    sha256 cellar: :any_skip_relocation, big_sur:       "c66bdf49260814408a74fd51f658f28eb5398d61bb9f2fb422e269acc08a2c93"
    sha256 cellar: :any_skip_relocation, catalina:      "b97efcba269149c456ab5b3913adc8d1e8458b1f3b1b880c6fc6789acd0cbd2f"
    sha256 cellar: :any_skip_relocation, mojave:        "cb04ec9019c20c619cb8cbc2f056e17ad20fc13cf66e7db7440f7684127d4f69"
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
