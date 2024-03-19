class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "90b3a38a76776fad1e6d989b4f4a6da2f877e6f832ad1d123ff608cffe2aab1c"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d1157d42611a31811ce97f8d6cee515cbb978d34462ecfea43e4aac4af6e6b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf1ef52de81dc8c8e0e363d85a362f210e9eb50b22f4dd378978fa9543025a57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204e20d34eed4b00dab8c47db9c7e11acb9f5a335973fd6351b9a29b36af767c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab34febe3b12d519b719dbe883728ab185cafc6d55157481cae92c591d9ce6b4"
    sha256 cellar: :any_skip_relocation, ventura:        "f6a8e1e670cd293aa7fe011e0af1d1049bfe9da06c2f65253d6c34a7f3da258c"
    sha256 cellar: :any_skip_relocation, monterey:       "6034cffd2d8df5b6d6e155cafe9d0bbaa7d2489af7e657883e932c02961d8cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd8c00472c34a63eebc1b6dff9325b4c14637b352664637648cce260ce96dedc"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", "completion")
  end

  test do
    (testpath/"test.tape").write <<-TAPE
    Output test.gif
    Type "Foo Bar"
    Enter
    Sleep 1s
    TAPE

    system "#{bin}/vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
