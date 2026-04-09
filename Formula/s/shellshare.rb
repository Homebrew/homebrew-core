class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://github.com/vitorbaptista/shellshare"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "68469121e9209eb9b916c2246d06af9f5408db66d9bc8fc916d0f9fed99001a0"
  license "Apache-2.0"
  head "https://github.com/vitorbaptista/shellshare.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a75120585874d126689d8dcc50415013565a05f9799e60841ca7c866562ff767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7127478bbceeabeede943aadd7ec56d527ec4c181eb2575b4d4e2b73023d0d22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7379c9be2667634f519714d767526841d810266dbcdde6929c8ff0da484da273"
    sha256 cellar: :any_skip_relocation, sonoma:        "2041ec7a35883314d0725f679e0e3415ffb8bc7ed533f33f888222d67661a27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde954a53f74d89b49b405d25aa2279426605cad5bad5ecf3db0d38b494a7c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b268e373ed7c1086a794db27afc947f3ace5580dfc203f1c6b938a6147ce3481"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shellshare --version")

    port = free_port

    Open3.popen3(bin/"shellshare", "--server", "http://localhost:#{port}") do |_, stdout, _, w|
      assert_match("Sharing terminal", stdout.readline)
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
