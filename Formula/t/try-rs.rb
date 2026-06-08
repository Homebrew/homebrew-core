class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "f7080db6ffa9d84f222ea45e9e9327742605eb21dcdbc6349e564a165a5a0844"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffa406d66fff1cc6cd8dbfa704689e317e4530e4078dd68624cd07c8d3f56de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b880d2c18ffda925071ad0ce18982962d653f2ea9126bda7952f205be69c087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e32f1644058bd73265538538f51743a7526707365696d84d15443d0c99ae30fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "93c6a65c2dd6a1760ac632203933fd7672aefefed34fedd4d8c8d0d58a636f28"
    sha256 cellar: :any,                 arm64_linux:   "649a864ccc311d665aee9312d884c742c37f02e9d4d31e22de7a97515f7ab7ee"
    sha256 cellar: :any,                 x86_64_linux:  "93a8a542833a961b04f9930a4696729fcb8e1b311de1710141f7aae5b3521505"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end
