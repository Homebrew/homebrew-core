class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.6.7.tar.gz"
  sha256 "8c29f30294e1cbf1cdfc4b4f23e595e9d683aac8a21280b7218e894824caa80f"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0d39cf21e21d67333f356390e8bbc154aa99d12c8e36518bff333f0938c9e01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7976c1c4d2655020d709a446f64f087ff13b8377d263be19e74d289aae1a00e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3364b446ee20fc49ff9463af49ef39b40d34915e258e63a4c31745c4f00568f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "da82689c17a941b96a4f2aae2259ca53fc3ed270a7fd4241ade055b4b8ddb5e1"
    sha256 cellar: :any_skip_relocation, ventura:       "ecdc721cd6c40658fb43016f0ff30ff693c8d865d018c2c6311c522bd8d4b637"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rmtrash"
    man1.install "Manual/rmtrash.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmtrash --version")
    system bin/"rmtrash", "--force", "non_existent_file"
  end
end
