class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.17.1.tar.gz"
  sha256 "0a10adb4a50351391ecb8fb8441ef21a0cf14acfedaa4e8f865517230ebda7df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e18b488d2dfd3937eed4d38f3396122d233ba0f917ddca25d5cc21027a726ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dd9f9a451270731203694de299572f05792375e0e64fb83d766d769ea1af78f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b75c3737537e833f0ace27a0b9ecc05d9daeb2ddd87d6135d4c10dbbc92f7eb"
    sha256 cellar: :any_skip_relocation, ventura:        "670f0dc1da715d69af91ae5e6b4533a44a12c0d48cec6617a69399851fa51464"
    sha256 cellar: :any_skip_relocation, monterey:       "be27dbb46a9e50e395c1f4e5c31a2714600c0bbb415faf96a1fccd1f372184a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2021fe4b6e607a641091a55e1d0f7dc48ea5ca9ebeb73bfbe1bbdd39d46d0f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6ba2ea01d646a522ab4239303180c7b83a990fbc728f175159927d35f1e1ab"
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
