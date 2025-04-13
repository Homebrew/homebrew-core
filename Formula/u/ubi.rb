class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0aa1e759736514ae22720e81cd935695724a84d352a3c7407e627acc9e36e816"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77044473c4211322ef1d39a83adc89ba2ab7ac866127b61bc940c651c5ff8898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4208c9b4fe77b880765080624e02c75e2f7953e09f6b637dff3bb99b10fed100"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed494e3cbe9bb19fa85c9f53a73fb0ce45e65900ba729cebbc969f1dfa9ce9ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "66a4c764f03fad10385acfcaff25b9128cbd641d3384b14ed093ba417da57894"
    sha256 cellar: :any_skip_relocation, ventura:       "b7ea9d319f4122c83f32db52eda9f3c86da3f1f61e07bf02cc15392e95ee5f89"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1802de977e5ef152ed0457ffee5a9b761758a2d4c10827d078554c5f79193b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e8937cdfce9e480918089a701cda089cd4573b6fecd8ca9c46b5c54e1484629"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "xz" # required for lzma support

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", *std_cargo_args(path: "ubi-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ubi --version")

    system bin/"ubi", "--project", "houseabsolute/precious"
    system testpath/"bin/precious", "--version"
  end
end
