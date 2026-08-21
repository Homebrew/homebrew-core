class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.28.0.tar.gz"
  sha256 "b2b679f0999d07fae148dad5247d4b4932f62a4f0e420eddb5dc5b9d0bc26a32"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b34b28e25d1ed39b37f7f601b3ed4e8242f7e6936a2ea84c993f7f55eb5af09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b34b28e25d1ed39b37f7f601b3ed4e8242f7e6936a2ea84c993f7f55eb5af09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b34b28e25d1ed39b37f7f601b3ed4e8242f7e6936a2ea84c993f7f55eb5af09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f79d7ce928ad0d0aa6cdc280fb4c9950fdbd2ba68bf0290371ecfbd93360a19d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4906ea4b48bee414a1a81c5a5e172919532cc2bfe01e0f6945cde1b9ea3eb1e5"
    sha256 cellar: :any,                 x86_64_linux:  "a4dfb6feb3d8acb52bf22bccafbfd660e34810225771158e3c7635538a4c7b2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
