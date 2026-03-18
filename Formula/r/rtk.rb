class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "f063ed2503d5c0e32569897dc3773755b8ddf144da442529cd7e9ae50c3854a9"
  license "MIT"
  head "https://github.com/rtk-ai/rtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f32278209bffad8c04a412fc8294a9c88f73f623327fe51251bc6eca9c79ace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "357e9ee32579fc4449004e4d0b94b0fd2635b720c6d8778bdc85feda50f911e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eebbc1961e58617401ff956ea191c25446fab9ada38343a41bc5cd609dd694d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aea0423853ce9d21ea4216e166db06a74170df12a81891fd5539b5d020be452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c8ba250247affcad042d0f21744828ede66f8343802c59c331597f816b32c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96db15362f8ac7c2e42cb43048d4f426872fe44dbd46897a155d82f8511c2b3f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
