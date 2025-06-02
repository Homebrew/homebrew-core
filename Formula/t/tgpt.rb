class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https://github.com/aandrew-me/tgpt"
  url "https://github.com/aandrew-me/tgpt/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "0e312176908d581eeb7f0df8fcd0524a4aa4702029d50f553f0f75d6c15bc0d9"
  license "GPL-3.0-only"
  head "https://github.com/aandrew-me/tgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ac29989e7df6f0eb1779469e3c07608422bcc9b9dd16a52f3d422f3b7522a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ac29989e7df6f0eb1779469e3c07608422bcc9b9dd16a52f3d422f3b7522a33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ac29989e7df6f0eb1779469e3c07608422bcc9b9dd16a52f3d422f3b7522a33"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cb050173265ba399c3884be9fd64fcaccf69931a729c66a550dbcfc47c41fce"
    sha256 cellar: :any_skip_relocation, ventura:       "9cb050173265ba399c3884be9fd64fcaccf69931a729c66a550dbcfc47c41fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822a8e1a33f876b00a794681e74f6c687a2dabfcdbd811bc345c8ef684309383"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tgpt --version")

    output = shell_output("#{bin}/tgpt --provider pollinations \"What is 1+1\"")
    assert_match(/(1|one)\s*(\+|\splus\s|\sand\s)\s*(1|one)\s*(\sequals\s|\sis\s|=)\s*(2|two)/i, output)
  end
end
