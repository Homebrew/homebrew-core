class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "cf6ebc722fedf34a146fab3eccc1a691439491b55457c324270d15498185ea5e"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d7696ee411984434615589675979a8c06e3c1939d9f271a1fea301434afa91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ce2ff25489b5cd4ab8c93c32007ed6e6804cbe5e0cd8eada2fd3831251538f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd75aed430a3d43bcd783999739c4b1b414fb80c01502579f15e50126a893127"
    sha256 cellar: :any_skip_relocation, sonoma:        "67c38f5ae31a3c2a1a57cf50728268db1dc289e29f855ba335dfe10460f3e7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f75ed9083a26a30241db65751e1ae0c9d1e75579d1e6394e743dbfc3c938439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c1b6c229274c3f424ccfd1ec3c181c60afcfb8d8090d6481d47ee5fa637c5c"
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
