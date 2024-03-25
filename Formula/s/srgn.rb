class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.12.0.tar.gz"
  sha256 "6b87c2c26da7dcbf97d875f742bc00428d23d5a3a1d0cd788918dfa1764d9cc5"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "78ccb521fe6996b8a9c6e89cd538b58dce3639301a9b2183636a7d0ccf83a2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4b24884f81e9161a97db343000f121be01c4ce57ddbaf42f19fa7d021df493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcee0ab1f88718ff81021a2b5c855f88300c88f264f03112cb5b2c1a1e863134"
    sha256 cellar: :any_skip_relocation, sonoma:         "033444b1153aa841aaf70beeeeb71caf2973212b0349524d2332265ad3a3a06a"
    sha256 cellar: :any_skip_relocation, ventura:        "ca1717a32f2d192e2d171d5a3401355261a4560c62d44f4f5cef3adb7bb65f96"
    sha256 cellar: :any_skip_relocation, monterey:       "f75ea3abd1e0c8ba796790b5577718ccc76f76e075f3118ca9c324a1349688e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c63ec55de8e524f6f1621a619c73c81eb87ab9b4833a447eba9f4919ebb19b88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide ******** and ********", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
