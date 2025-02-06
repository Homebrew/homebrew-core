class Ubi < Formula
  desc "Universal Binary Installer"
  homepage "https://github.com/houseabsolute/ubi"
  url "https://github.com/houseabsolute/ubi/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "90127c22d0ce302f43ca32ef1fc5ae227b1959afd369f9a9175681f56d802ae7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/houseabsolute/ubi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbe9ab94c8afab79a5d8fb64f0a0ec9b2fafca91be3f00c0166107c7b61289dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46a430be09b9597ce032d110d619a628e862467c155b679e5178c1477227c41f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6789e16290de460e4b25e73e0d6d55754ef96cbbad1ded9eca3c9c9d67c04134"
    sha256 cellar: :any_skip_relocation, sonoma:        "08aa630bdd3c7964830fc3af64bf216c7e0c8a40ba2a016674ed939cc533cdc7"
    sha256 cellar: :any_skip_relocation, ventura:       "9cf6746f30a0344124a7d22e1bda66a4dd71398e38a3a58f6066dde08773942e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bb2987b90127c3c8e3c02d0d708edc793a20bc43e3516b13fd297767ddc16c9"
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
