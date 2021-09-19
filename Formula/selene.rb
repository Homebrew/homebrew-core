class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/0.14.0.tar.gz"
  sha256 "7accab1f2e2c32af7ca3a28da91f0f3ff89a9437a4d6008a9514f13009912fe3"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db9ad90c61edc0bdd85f36287a857c881ce85488df4a545c7f43623ba3306c06"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f79d5199778de50445897b61ed796ba2f8ed8dc28ba94e3178566120eb5c53e"
    sha256 cellar: :any_skip_relocation, catalina:      "f327afafa10d044c0b295e16741018c368251b79d65318bfdb9def511740fad5"
    sha256 cellar: :any_skip_relocation, mojave:        "748941051771e799dd0afe0e853f007746cd07af86134fb8f912aa5c3c7a5dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3061b7ea81453f2cca3b71aba7f1069b8de067b24267626e95a7fa891a12607"
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
