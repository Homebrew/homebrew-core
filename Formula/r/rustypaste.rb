class Rustypaste < Formula
  desc "Minimal file upload/pastebin service"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "4b63be093e080d4a39e9ca03b378df96f0ae604e469a9c4d9bb437f9643524f0"
  license "MIT"
  head "https://github.com/orhun/rustypaste.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "536936250be096191b52dbe20f37d5b00dee7fd9be4081220eaae1291e40499a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ba557d7bdc3a7c10ad5978e34b704ae40e085efa8435bba2d8195550b024fbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "414a0d30ce3bf2ef50ac249590c3b929ac65f67aca57a97de8bcb1db9453cc68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "628bfee10f8b8561301cb20f6e3d3402925ddadec2fff1e4482cf1c6b7d1c265"
    sha256 cellar: :any,                 arm64_linux:       "787057329745073c39c4d8b4089cc7abbe10f8853a0fe2eaaf08fbd40b802269"
    sha256 cellar: :any,                 x86_64_linux:      "fffec98cd61a2e5df8fba73018c18d27b3ecf3e6f9f3c87f1b675caa0bf3dab8"
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
