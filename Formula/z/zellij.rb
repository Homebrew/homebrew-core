class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "1f0bfa13f2dbe657d76341a196f98a3b4caa47ac63abee06b39883a11ca220a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2183f0c3592b2fb0c9874c94870a3e303c2901f28e2370fb8e71d89625e4ef4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80d0688a3f2fa76ea9d9417bd9db0ecd95932e9280d34471de8937e184116988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1071a258de8cc07429de27543aae2906b6a84cef28cf35992f9c4cf09ceee350"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e32e1561b876067d7b022b50fdc69620dcd4d3697a765f9f5f352b215146139"
    sha256 cellar: :any_skip_relocation, ventura:        "e3edbd1ce4233a65b7258cb4f6f21e51a055eeae09806ebcead11a3a92a5c0de"
    sha256 cellar: :any_skip_relocation, monterey:       "d27b158af0acb038d5712603519e9ee8ebf322873a6cbd7c3f3c686059f9b08f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b21f2df5cc8c18fc9cdfc7b819c76b24a8a57710872dcee8a10e2c5a03e80712"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
