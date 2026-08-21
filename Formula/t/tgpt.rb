class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "950af3b39f5870d0659c88ae195b46553580e5d96c31f2230b7eb159d774e7b4"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "553f2c71a98e4e59cc7674292b74362e8c4680c0acddb4925fce1c12d0f9368e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f4ff1b575f88b526f25c6e65f81397513363709cf803461724aeaf19d30c37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3d68c0fc636d6b6dac9a58a7ca624d1331a5dc66c7fde3d4d126a0f2b677a7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "df19daad2778c312116ebfafca859a15190f4093679d77f19ee0b460ae5a59d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "632b288df6bd65e70c075bbe8d70f51ca04571196ea90db32bc9160405bd705f"
    sha256 cellar: :any,                 x86_64_linux:  "a5065b17823b8a80ccdea3147e3e699e12daf1855495bd05d173e3cd4d9a6a60"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt \"What is 1+1\"")
    assert_match("2", output.strip)
  end
end
