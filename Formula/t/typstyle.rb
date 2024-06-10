class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.25.tar.gz"
  sha256 "078c5aa2db919ea8e14a675c9f32a7339ac28010c97aefdd952509980dbcb39c"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "028ea6af12cbfcec95bb53404c710ab3304b5f86a14806cda366b063270dbc17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26af0a49bab971ec93bcf12b5e7d9e47f466329d7e198536c66842dad4c2ec02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd5746585575c9e0573a5126c6ef1a8f371cd90f29e1825682d11e2d9ecad977"
    sha256 cellar: :any_skip_relocation, sonoma:         "f08b88af26f26cb7813fac311616bdc657e3e877f2c6fa8a76f3c86ee951a14f"
    sha256 cellar: :any_skip_relocation, ventura:        "3962561dbed7a7b4673586075e782f033aa960c16a349160a6f13105886f3b55"
    sha256 cellar: :any_skip_relocation, monterey:       "cd7317345c31a5cd8eed03ac8174aeca5fcdea749b1aa9fc850ef60c7dce8065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff0e01fdcd8a8f17a85bde70bad476cbbf20ccb6b59071845a90949ebce95e58"
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
