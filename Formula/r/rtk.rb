class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "7cee0b80fed546a3c3508b485cef1129b56a14233ee02bd512975c2ad3356643"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "807b14fcf36aceb68923d3ca9186cac1840de5a5f4b88aedab40fa55e16abb97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58b88696ccb04deb60c39442db78730c01623189833c5d3981e5e988e3f8b758"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d2704d04f2368c85327e12afa0603ca1ae48ff22898a6a30b1b55cb9a87650b"
    sha256 cellar: :any_skip_relocation, sonoma:        "74e3ae699a14d385a13336977658e97c94b9f43d6cd2049a9292500ce2a19bd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1efb5fe509467b9f802bf6001cca53d00a92e3c115ec030fc9b4271b09f7d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0210ada08453639fa6bf00b64c1eb3de50a4c1dc0f62fc7434b3a606e2c66e39"
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
