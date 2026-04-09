class RustypasteCli < Formula
  desc "CLI tool for rustypaste"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste-cli/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "409245145c94ba5f0555577e9e3e723d8e10585bb826e5c8b2f88b1b533b0783"
  license "MIT"
  head "https://github.com/orhun/rustypaste-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16c8833e77ed63d0abbcfbb9b0c34fb21224f6a91e2c286fa2cf0f7fb47042ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94c4993dd5c74b391ca579a4f16b735ad4447f4033092f688f2c9488e2b8f9f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82d3e750e1439f0de5a657ce2b59dc0ceebb0bb31ee59baf2ed93dac238bfaee"
    sha256 cellar: :any_skip_relocation, sonoma:        "974595d6b614813f280c4350970ca054abfd73892c919220786f2f455389570e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95e51e8b975739bac321b1eaf2fac42d52281ec806b689660fe5bcc76e0f151f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e188ca87c16a76fdc518d9fcaa997f24770ef72c5689dcc171fa89f44dfd362"
  end

  depends_on "rust" => :build
  depends_on "rustypaste" => :test

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
    # Upload error: `invalid file size (status code: 400)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    rustypaste = Formula["rustypaste"]
    cp rustypaste.opt_pkgshare/"config.toml", testpath/"config.toml"
    port = free_port
    address = "127.0.0.1:#{port}"
    inreplace testpath/"config.toml",
              'address = "127.0.0.1:8000"',
              %Q(address = "#{address}")

    (testpath/".config/rustypaste/config.toml").write <<~EOS
      [server]
      address = "http://#{address}"

      [paste]
      oneshot = false
    EOS

    begin
      server = spawn rustypaste.opt_bin/"rustypaste"
      sleep 1

      file = "awesome.txt"
      text = "some text"
      (testpath/file).write text
      url = shell_output("#{bin}/rpaste #{file}").chomp
      assert_equal text, shell_output("curl #{url}")

      text = "Hello World"
      url = pipe_output("#{bin}/rpaste -", text).chomp
      assert_equal text, shell_output("curl #{url}")
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
