class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https://github.com/bensadeh/tailspin"
  url "https://github.com/bensadeh/tailspin/archive/refs/tags/5.4.5.tar.gz"
  sha256 "8dec5333c8f3e9cb6f29b4823482634b3c10e317aae12d0844d73ccfb1307a13"
  license "MIT"
  head "https://github.com/bensadeh/tailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4b49594699cac9354f9430ca2b78f4e302e0653ff78f2877a835f59fd601cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ac1f9b3d73e0e75aecf72caca3e8354cfd6e1a5fae4387511d9805adb881fe1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90986de2ba4306cf0398206ee5f84698b31fd647317e43326b7d86039a50b46f"
    sha256 cellar: :any_skip_relocation, sonoma:        "10ee21d6a0166690c9ac2963ac7a3101f20339b687c1d20a1ccc462d8f043a75"
    sha256 cellar: :any_skip_relocation, ventura:       "b4e2c60fe4a48f8b92ab810ceeca861fb3bbdcbccece735d2129c8e941307130"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3ff3a85f4c7d8cc32c0a7872ee7dbaade643b63415b6bf43978dec6c7b8267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4053cfae760b0576b2921d89e5ab97375036ac78ee53261849f55a207d3c2f47"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/tspin.bash" => "tspin"
    fish_completion.install "completions/tspin.fish"
    zsh_completion.install "completions/tspin.zsh" => "_tspin"
    man1.install "man/tspin.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tspin --version")

    (testpath/"test.log").write("test\n")
    system bin/"tspin", "test.log"
  end
end
