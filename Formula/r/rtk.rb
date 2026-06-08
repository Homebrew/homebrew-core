class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "9afd0b11a60100cd73b9b6bc8407d9bda86ea5c40529b60429db56efaa3ee7eb"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb0495de1962bb94379678b727f3787445bf6ec76159c0ab5e10d9ee44cd8f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c741bfc314f565e8798a21b20513a8472228d1aec148873255c4bf0f272b388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7269f24918b1a56a898707759190ec03794e420bdaddf110eb6bab0b779ee485"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cf6d8ef6151d60ca89bb07acb9fdb9a86f559453f0dea4a772704b1b8824099"
    sha256 cellar: :any,                 arm64_linux:   "99af623647a1d9ed432d57121ecf2a4a9e753ea56bd731f06290725ed05aa88d"
    sha256 cellar: :any,                 x86_64_linux:  "4bb177590a4f9c31bbb4af6d03caaaee5bd85dab882a1ed262a55e4c3291cd54"
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
