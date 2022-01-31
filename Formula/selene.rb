class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.16.0.tar.gz"
  sha256 "35879e6cb85993935481e2940d3532fff787733f940cbe27bbede70f84aea496"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b023f8629059e3e0068fbc8ee3ba24d3064b697c5e661b4b64ab27651a78ee73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7404ce9917227fc3fed3a2daafb0289549cd849e9d955f0638534267b49cc677"
    sha256 cellar: :any_skip_relocation, monterey:       "6bf55e064c3ec6a3245bec4954b9cb028ae54350ed4f77cdbfca1047cfa653e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "864a4566000b5617fe51bd4a03de7065c1d13c9cb5ae0bbcd875de0d7fb379a5"
    sha256 cellar: :any_skip_relocation, catalina:       "3e2d4193bc5e02d08851e5d42759d3e526707e0fe5906da3e6226d20feae1a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd28cf78de4aa7b9bddb50deb786ca474301fbc2a3db42e573a4d99da545b95c"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
