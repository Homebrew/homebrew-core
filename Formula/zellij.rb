class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.33.0.tar.gz"
  sha256 "63eaf8ca0c1235389281e3ee5f599b810de3921d220e500cb35c46ec9b5125ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1239891035d953598c95a4864a7b9bedd5ebaca05abf05738a7480c2a57666f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31da99ae9c2a5665f91cdffefad701cc3bd0a889876c4a92fbb2e593b2f879ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fe88e2cbd9e87832a02df07907b2c910ec741b4688e496d07503c0233e37fd4"
    sha256 cellar: :any_skip_relocation, ventura:        "ed0d9d4dbb94ccaa2fd070b829d517166b9369cee3f5cfce2315521854482983"
    sha256 cellar: :any_skip_relocation, monterey:       "4bae6dfdebf4faa345286f5bfb9e4d3b5380e976b2733742e2bcda52305354ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff544a7458565c4d805247e3ccca5dbb926f776108960dd4c537d17b7826489a"
    sha256 cellar: :any_skip_relocation, catalina:       "b7153bc93afeff55e4d301eab7df19545f43f0b01c1282d4691f746f02a2a12f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b244eeba49a5a87b90a371d716f5e8cbe879adafde78269e60ff93c3de6df5e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
