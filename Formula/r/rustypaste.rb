class Rustypaste < Formula
  desc "Minimal file upload/pastebin service"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "9468d87e536a7557612470f448d06fb6393e21eaa464eea0c9871cae0dae4879"
  license "MIT"
  compatibility_version 1
  head "https://github.com/orhun/rustypaste.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "07a58da0969fc70bf6740d01e0ac99cdb3a2edc28b5d3f4a6fa0e17e5537f380"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "894b9f70062db6f951237f209dfcb0cdbf0fb3302e02d1553707cc18d51816b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c31ce043892b721d24102da4973f3785873c478c2f21b4ca9f5b98b23627ac54"
    sha256 cellar: :any,                 arm64_linux:       "80043e22b5b1d0567450be05e23b711ccf69935188bfb4373c47139379cbb3ee"
    sha256 cellar: :any,                 x86_64_linux:      "95ae2674cd3497991c45c867ed61ff52bfd9b75955930057a53f941f6b29ef7c"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
