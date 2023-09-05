class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.6.0.tar.gz"
  sha256 "bf41f264730f18b5146c2269d82b5b69757470799a2cce6099e420b5f3ec7fa3"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87adc926741c2cede54d4b6a453862407cd3cde38d93648832090a8a11a963c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87adc926741c2cede54d4b6a453862407cd3cde38d93648832090a8a11a963c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87adc926741c2cede54d4b6a453862407cd3cde38d93648832090a8a11a963c2"
    sha256 cellar: :any_skip_relocation, ventura:        "191b7b279c041b06d8367b16da08aba9640080dbf6b2c0f0cf0a8838bb179b8e"
    sha256 cellar: :any_skip_relocation, monterey:       "191b7b279c041b06d8367b16da08aba9640080dbf6b2c0f0cf0a8838bb179b8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "191b7b279c041b06d8367b16da08aba9640080dbf6b2c0f0cf0a8838bb179b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c032bb97af62d82f7103e8aee68e6d5cc9e7a9f0c13b89dd7021498342fdf52b"
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
