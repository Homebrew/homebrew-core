class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/2.32.0.tar.gz"
  sha256 "7ff47d9becc3151506fab3263c6ebebffbddfc9a36eec0fb158cd364530fac11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d8c54dc4c248ac3383fd21cab70c23bc91b5f8a5c8f0a59e13ef0f44ea968d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "002c94ae3f46ae474cad8755e4773d6b2defdc50bcc122d44c0b61886a928993"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07eb7a8272d7abbf0b0cec18a231d5fc98dbb921800e451e84299dd1187a9806"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f46b5168a09390172517fe6032b702d4141b8ef48ca37cbd89dfa62bae31fb6"
    sha256 cellar: :any_skip_relocation, ventura:        "4ca3f50239632e8c20b3e1db4b31f1e882e59f92ebee1342723804aa0673c618"
    sha256 cellar: :any_skip_relocation, monterey:       "1dfcc1ce21a213b26b80127a84a80c98e060e0a449460521cdb50e6c4c7dcb66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "957531371f8b7c0529fe9758e9732857449ed2c0b7b8a068ae56e5077006e695"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
