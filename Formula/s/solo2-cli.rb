class Solo2Cli < Formula
  desc "CLI to update and use Solo 2 security keys"
  homepage "https://solokeys.com/"
  url "https://github.com/solokeys/solo2-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "49a30c5ee6f38be968a520089741f8b936099611e98e6bf2b25d05e5e9335fb4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/solokeys/solo2-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac06ba094da706b68c527fa6904187aa9c2d21fd26246bf9a343a4a14a4d8dd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c876fcb91927f6c382994c92cbd8fcf3041d12ee2e43f6239c325bd852d4d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30c6fd9a7c4eaa8345fc68740a10232ffe26755d9c19b3bd4f7f86e650471d3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b0ce4ae4cc661cb11b6746b536e736256c6a3b978af3508ea36997bd667d0c9"
    sha256 cellar: :any_skip_relocation, ventura:        "9529d0379455886612d51ade076b55ff1bffe3395b09fe80edba6ebb571d119c"
    sha256 cellar: :any_skip_relocation, monterey:       "ffb93967fd1171798157e502212337d93d644f6e31f8e1457f17c0c62f088a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c7bd01f05ac244c1b50fbfc559a9dcc641c23d71a2f9664e8d88d22a522316"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
    depends_on "systemd"
  end

  # rust 1.79.0 build patch, upstream pr ref, https://github.com/solokeys/solo2-cli/pull/122
  patch do
    url "https://github.com/solokeys/solo2-cli/commit/c4b3f28062860c914f3922ad58604f0bc36ead93.patch?full_index=1"
    sha256 "1f3e08c4c6f17022e8762852ef8e2de94e1c0161d4409d60e5b04f23d72b632d"
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args

    bash_completion.install "target/release/solo2.bash" => "solo2"
    fish_completion.install "target/release/solo2.fish"
    zsh_completion.install "target/release/_solo2"
  end

  test do
    assert_empty shell_output("#{bin}/solo2 ls")
    assert_match version.to_s, shell_output("#{bin}/solo2 --version")
  end
end
