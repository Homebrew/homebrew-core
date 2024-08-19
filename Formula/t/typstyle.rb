class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.32.tar.gz"
  sha256 "7e17020c3de841e61ffaa43686a309e8bd2b0c105a303ee4ff1084f6a39b4074"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e0e0ebe5fc9d00c0843af5fad4226b17bc224439f631cc9c6b5557b45f13515"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bab9421010f23ac49530ec55f85190ab620f9af363a85a390a8116fa5f87cc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5a73f0970721d9e404cc5b8a053a968a22bc3cf8a778cb9633989f43abfed6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c1942bb745c1e190bcfc69ebfb96fb2fcc772a8e8c72246519fbd66db2ee439"
    sha256 cellar: :any_skip_relocation, ventura:        "8bf81c869e0a26ff2a3b7fdced0c04a68d95d4cfacede952331a23c3d210bd75"
    sha256 cellar: :any_skip_relocation, monterey:       "da328582d195962ea0fd986ada2f54655c9b42fb92ec35915770418864d0412c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "098dd39295efa8074f1392b70c84ed0a237b81e6be46e924e88c7a95fb9b5aa5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
