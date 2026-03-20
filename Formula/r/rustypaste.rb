class Rustypaste < Formula
  desc "Minimal file upload/pastebin service"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "7e3154888b90113555a0d5dbe40dae83f5ff2fdbb32b3aea998eb3fc79ebce35"
  license "MIT"
  head "https://github.com/orhun/rustypaste.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f740c83c45ab964419367ffeb9ee8120affba10e4101af891e8c93fca04520b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7549c6073caac74eac78311b23f4749a4e9c4bb24004bb3388dace94c6ca68d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4401816b4bbc3fb5cb2ee642c23777f5f4341458d5ab70d72fb2cd71a9cd919e"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e9650aa4526b365b5f95873003221577ee2709d7f7ea1e68e0328b810bec13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbce6cb426fef97c071dd06872cb7ebcf323c1a5c3dfb291a7d12e5d9ad6dbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493ed14e58870919b7b0e7d89eaeb71298b836acefd00819db24169c61a5a9d0"
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
