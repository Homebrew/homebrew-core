class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "24b6c17b5d948e04149bf35bfc42889ec60168c2a158ae6f90589cd993099ba5"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c74fa1c7d3006a174be6c98f6be14f4f9c6de0d0d6c6facbe43be7eb7be34995"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66423d6aa85b8d163edaffd939bf95b0c2909033ba9fc165e2462cebe25c13fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4eca5073635978b8b2348d25416fde7ef70bc0f71791b5170a24ee447a0bba"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc601e1e7279f75ee8bec0c8770224119dcda9a0cb39ed2f13e9637c0577f34b"
    sha256 cellar: :any_skip_relocation, ventura:        "2778318216e7f8db2db91811ddbddf6687f0c228640f97db76ceed831935b130"
    sha256 cellar: :any_skip_relocation, monterey:       "6d964bcd8c8880bace1d36d04a2953cf3802210412253c86d33a1bef30d5adb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1eb99851feebefe7e53eee636bd494c90daf6eda44cb6764d096bf1da488ee7"
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
