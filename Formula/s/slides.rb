class Slides < Formula
  desc "Terminal based presentation tool"
  homepage "https://maaslalani.com/slides/"
  url "https://github.com/maaslalani/slides/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fcce0dbbe767e0b1f0800e4ea934ee9babbfb18ab2ec4b343e3cd6359cd48330"
  license "MIT"
  head "https://github.com/maaslalani/slides.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3abb6c16fba8fcf299fba222be2ec0cb00cd3eec6f76feb45e13b13e6d79d68f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "755ccfe47079714863054effd6f18d4da28b579895c56d69ba4abd506c2c65d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d474822334c4c065d42e7c81de42e4924afca758106f358cdd755e454c13be84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "335ffbac50cfea46abb4afa92116f16c1d351d77deb103a19e6434b11d2a540d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a17e1f07ab13a27bca222b103799a247e15d2bb6f3b239d5f973029886e4e1d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0faa8a0d8f1d87a0a16a294b35e5d98528be06dd4069aca905d5fdc7464ab73"
    sha256 cellar: :any_skip_relocation, sonoma:         "e098599b758587a78384c17188389d9cd963e61de285d9010001777ab7d12342"
    sha256 cellar: :any_skip_relocation, ventura:        "59795376dc3819201011a4f97014d5510b29f5b2056760f21cb78b92e2e1ec4e"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffaaae9819ccd022e0e2a7091b09389ec26bdd1eac7e3ff9c97b494a887b9d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "47e7d151b73e9132506410808df33d3ee8516d4739d53fda0d8cd759d7ede76f"
    sha256 cellar: :any_skip_relocation, catalina:       "142e0dba029f7c87501f7a0460cc9e909819ed60f81e3da4255000a553275346"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "160d6346dd5d2bdfb54046afe29bd912fb1a481f11f063ddbf6a01380af15b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bcfad497512ded3dbe7ed81e2683a3c67f211c0a811c7265d171e79212eebfe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.md").write <<~MARKDOWN
      # Slide 1
      Content

      ---

      # Slide 2
      More Content
    MARKDOWN

    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position. For now we just run the command
    # for a second and see that it tried to send some ANSI out of it.
    require "pty"
    PTY.spawn(bin/"slides", "test.md") do |r, _, pid|
      sleep 1
      Process.kill("TERM", pid)
      assert_match(/\e\[/, r.read_nonblock(1024))
    end
  end
end
