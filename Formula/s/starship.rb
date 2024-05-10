class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "505100002efe93dbff702edd82f814cadc340335487993e76dd6777dba461a7a"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38e579d1d0b477e004118a7d61125692a76eb00b01f1ae61531a5de52a7d8fc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e8147b20a0e7a3a9764d661da4b5fc1bc56592ec7e49e2425ebf16f1717452"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf608eb41a558493c4dbd89d930954a1a2f8d812a027cf87a353e312a0973a53"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ba8017db4aa930e60a95959657f79bbf2657aa11ec7997dc7c40c91a99ea47f"
    sha256 cellar: :any_skip_relocation, ventura:        "bcb35b10e86547b05b46cfd1cb08ffae81a820a26e561a0b1e255a8ef23101f3"
    sha256 cellar: :any_skip_relocation, monterey:       "82825059b6915e6c03bb5d956bede8bc1df680e4ab038ae554b480307fb7374b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "176ebab8a44b0f9a563606d1c97d7e8c02f2cd95517eee8df4901270ba362894"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
