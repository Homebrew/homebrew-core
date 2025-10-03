class Rustcat < Formula
  desc "Modern Port listener and Reverse shell"
  homepage "https://github.com/robiot/rustcat"
  url "https://github.com/robiot/rustcat/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "59648e51ab41e4aeb825174dfbb53710207257feb3757521be98ed28c4249922"
  license "GPL-3.0-only"
  head "https://github.com/robiot/rustcat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0f256a32dd3e5c5ad46cc6c79b7374846ecb650c452fd78fcdac210c73cff878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "36254916f109ade147614d6b7e97c2794453474999dfcc54c26677ab546568e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb05ce140c61ce7bb73d8918f5527f754fa894105c266cd8e1026796d236163b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04ab951ad077f89bc6636a7f9fd30eec76caee2b81e58608690b9b6b04c761f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82ee2abc1d590fc2f6e978be9cc87895a7c942ae693d513c2c1bd608afd588c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc1e37c738ec53c2dcaff6280fd34f7232e75223a04663b6ca6bca9517c1b86d"
    sha256 cellar: :any_skip_relocation, ventura:        "7df0fa8da7aba156aabbeccaba819e066d2a8f9a24ae7f542c0de428f659bf51"
    sha256 cellar: :any_skip_relocation, monterey:       "4bcba001f9e2c61676c29ee11fc1d5c10cb47210ea9434f26ab7781dc5334af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0cc1463d3f149a41f142729ccb167e002fd31f95d07ed6df6a4bd9963a14cf7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4acfb8c1ed49a339a21f694b8763f939d8e84968573bb3a397efd6d8975b4fb3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    r, _, pid = PTY.spawn("#{bin}/rcat listen #{port}")
    output = r.readline.gsub(/\e\[[0-9;]*m/, "")
    assert_match "info: Listening on 0.0.0.0:#{port}", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
