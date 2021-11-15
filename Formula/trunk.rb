class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.14.0.tar.gz"
  sha256 "c72914740b6b557c7b0b0c3cd97bf104abb020f5f4dbe0bf9e201c3d18995d61"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fd3194821fb98dfe898d09a6299a80498991bfdf6d8439490aa19cbf24b3215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68a15fbec3f247e910201dc63f748a97e00867c85176bd153ec010684c338dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "1b5d3f9b5903485cc6a37600f898b415793ec68fb5fb96790304f3203fe4d43b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c155f100ca114266d87db1737e25ed2fa59a427156ca184c494b7f88ebe02fbb"
    sha256 cellar: :any_skip_relocation, catalina:       "039d601d002b042cab1a1d12402fdd0d8e8660fd83341a50be5fcf92676645d5"
    sha256 cellar: :any_skip_relocation, mojave:         "1de2e90b44bcbe2b505f251a1b9867b2837ad442447f35e9d189583de139bd69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b50b8c680e87c8edfe3276de12b0bd50835cce2fcf0de58e69f891f9670a8b0c"
  end

  depends_on "rust" => :build

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
