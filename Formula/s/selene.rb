class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.28.0.tar.gz"
  sha256 "c51acf52e7c3136cd0b67b9a39a4a447c8f0257371b2b2acc7e77587260a377b"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8160e3e3b1589956eb8c952c94dbdb6e9417972007bd3740026dc5caf0eb195"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e2f4d3b17a7b036592845a4586d4d82e491574c374cb1c4f23fed3ff78589a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c76305c6d5730c2e20096085a8af6d6b436415600c2d12e4b25363ee0b6474"
    sha256 cellar: :any_skip_relocation, sonoma:        "512897fa1880a3afab978ee53662c2bc06f1118e9fa8c684d28db5bfbd6e9162"
    sha256 cellar: :any_skip_relocation, ventura:       "98d5b6b93545d9d50608f6cc832ad8af6a9a35dfca94804b8c15b67fc6ce87c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95bd12bda47d2fcb53978952250d17e8413fee634ed0142bf51a27833ee03ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc9d1abd031c82dcc47fdd530daaf4ca6555da8b7faf4e8bedfe3f45473ec05c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
