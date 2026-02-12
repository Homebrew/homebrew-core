class Tuckr < Formula
  desc "Super powered replacement for GNU Stow"
  homepage "https://raphgl.github.io/Tuckr/"
  url "https://github.com/RaphGL/Tuckr/archive/refs/tags/0.12.0.tar.gz"
  sha256 "2b0e359185384bcbc0160a2074dbf4c1e8fdde98c4d1a74ccb0a5af7ec753b00"
  license "GPL-3.0-or-later"
  head "https://github.com/RaphGL/Tuckr.git", branch: "master"

  livecheck do
    url "https://github.com/RaphGL/Tuckr/releases/latest"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba342c8c41b3672c46158a076ecd403e59bb1fbee8707a068075682ea6cecdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6f27026639472a51c3e6533cc6990ee5315f0682e3f43bf410003ae884799fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43f756de8a7db26e34c797177757952def7f9123532c14b11130c9933559e145"
    sha256 cellar: :any_skip_relocation, sonoma:        "309d59bb8359e672fdeecc5dd441349a151a7f33dbcefaa2dc9b7129bdb2bd58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f297c0b32effc6a51133c8d6f17fcf98f2af5ff070b9ed284459e5606e01a1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12abef9b77e858758c9fc3d630571013cb891cbe7ad17faf8df364adbf9f0fd2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tuckr status 2>&1", 2)
    assert_match "Couldn't find dotfiles directory", output
    assert_match "run `tuckr init`.", output
    assert_match version.to_s, shell_output("#{bin}/tuckr --version")
  end
end
