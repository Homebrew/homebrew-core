class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.27.1.tar.gz"
  sha256 "f12579907c019bebcc3830e320614409217096e63d80b4704989bbd65394b530"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2c0d800c3878bca89cb1bb6f13525f1d2bddd33673ee97d766a39af6d79c89b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f13429933319c05c75e4bc71235f335336e6989d614055bf2abc030b33cd79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd9cee5e52f5ca3362377ac5d8cffad27982de85d9251aaff0e3a52ffe7905bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee8298158be76be9ec0451871344c0f5dcd771c83f70dd555c1c7f5640f69d08"
    sha256 cellar: :any_skip_relocation, ventura:        "c6df4e0387dde9e666642a17a42dda1745fff63fcdafe5e82223196ffb60b2df"
    sha256 cellar: :any_skip_relocation, monterey:       "f57e9457cf71fdfd0b7832ffcdc2be71ec2841427571ecb47b29c8f667854e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4d71fc14f4f300d65ea59a478b92252e26c313ed39ab0424584a1c4fe9804c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
