class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.12.0.tar.gz"
  sha256 "afab71d67a8f139c1d2c0325654c8165c1daa36f2baffb83903c8faaa6a1850e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db029be98fee3199772344f6b0dbac2c618dd9803b554ec80c299b1ba587c391"
    sha256 cellar: :any_skip_relocation, big_sur:       "56e401e680d3aac8ddc7a3b0f528143ee65649821c0b8ae16ec0f9986943ab30"
    sha256 cellar: :any_skip_relocation, catalina:      "d8da1a17df62f0fa0430d4046be4014bdd12b2b274d24cdac6b089831e824cc7"
    sha256 cellar: :any_skip_relocation, mojave:        "d1691cc33b907571250b5b1cccb9f42022f32e7dd30c0de4f7c1f28291b900cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3890254423b3f02008ee6180b0631ac44b1ab19f55e399602f942f26aec7aa90"
  end

  depends_on "rust" => :build

  uses_from_macos "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
