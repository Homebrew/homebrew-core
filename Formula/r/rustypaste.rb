class Rustypaste < Formula
  desc "Minimal file upload/pastebin service"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "53db137b8429f44d9bf700063fc42f1047460a60713cac801a5983946facb13f"
  license "MIT"
  head "https://github.com/orhun/rustypaste.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "802cb98ad814a3984f98b38a3306706b63ae590cf87d006f1253dbbb1e33faab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7badde7285cb1b6ecf3a0677abb0a547af134f2104c0a99598f76a9a7f7cd1a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a65131e6263546728bd2e131e058037b5e91dad4b4de73e9b53e85623689c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad50f05f9144817f6a19eed5ea26594c957621675ee582b8c4a91c3f09bc004"
    sha256 cellar: :any,                 arm64_linux:   "17c58ce436361c03b05ec4d85205e4de8e2919203287321ebfb015c65a9eb83a"
    sha256 cellar: :any,                 x86_64_linux:  "a9cc542716155d55681257e8edde37e17d38101a99c5d9570a303fe19fc37038"
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
