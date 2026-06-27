class Rustypaste < Formula
  desc "Minimal file upload/pastebin service"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "1fac087e51b0a635e0a3b2110dcdc34284493b0be70fd6c45ebbccef6f26a610"
  license "MIT"
  head "https://github.com/orhun/rustypaste.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "400cca22276e40f0c2225ea7f5e651c1cc9d7580d106b487a8c7faf58283dd4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a29fecb11619a84fb25cb72bbea79836e91c34b900a7659237f2c9d0e86560b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31effa8cd271b0ffadb2faf5b4beea925a130c3565fff96b1bb591acd2f42107"
    sha256 cellar: :any_skip_relocation, sonoma:        "5926bdd6eeec5cfb000627980fda648d6e13da689b859bf5f5777b10237d1c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e529ca97192236b95261a2b6516c3fca8cb0407d8ff14475973b2897fc6b45f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368113442cf860e4263f5a176853267ec44ce3cc7f0d47acf741336ba48c8536"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "config.toml"
  end

  def caveats
    <<~EOS
      An example config is installed to #{opt_pkgshare}/config.toml
    EOS
  end

  test do
    cp pkgshare/"config.toml", testpath/"config.toml"
    port = free_port
    address = "127.0.0.1:#{port}"
    inreplace testpath/"config.toml",
              'address = "127.0.0.1:8000"',
              %Q(address = "#{address}")

    begin
      server = spawn bin/"rustypaste"
      sleep 1

      file = "awesome.txt"
      text = "some text"
      (testpath/file).write text
      url = shell_output("curl -F file=@#{file} http://#{address}").chomp
      assert_equal text, shell_output("curl #{url}")
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
