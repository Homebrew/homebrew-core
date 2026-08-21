class RustypasteCli < Formula
  desc "CLI tool for rustypaste"
  homepage "https://blog.orhun.dev/blazingly-fast-file-sharing"
  url "https://github.com/orhun/rustypaste-cli/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "cfa4fa94d950c59eb0474e2387e0171d77fba3abfbecef4ffbf520dbb897de44"
  license "MIT"
  head "https://github.com/orhun/rustypaste-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c439aedd2a1b304aa65c67e268a720a0e927bf21052b74839b8a2ed99c7b0041"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5820b5ec3076f8de2890df7df221a7aea838298ef505a275bce60b0603ba601a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a0cb0fe7bde5aaadc7951eb1830537c693193d91777e333f4ce795025a1fe58"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3d71dbc3fa8e87c8a4b145d74be90af18fe14f04419c17675ef9bb07c49137"
    sha256 cellar: :any,                 arm64_linux:   "021f157cc5b6aabe8300940f79e47ea2d9765a62d6976a3f4d94b140bd3064c3"
    sha256 cellar: :any,                 x86_64_linux:  "b1575145ba1b84e9df8cda0e1a5cb58b5bc9db713a461871af56a75928f4da63"
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

    (testpath/".config/rustypaste/config.toml").write <<~TOML
      [server]
      address = "http://#{address}"

      [paste]
      oneshot = false
    TOML

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
