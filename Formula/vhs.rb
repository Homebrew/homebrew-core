class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/v0.4.0.tar.gz"
  sha256 "4192ac0f52961ffa83fa56407b130f493cccde7d9904cff280e48aec807ac579"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31c9c02f43f1e6b778169bf5661082d4b6c8a35885806da725318c217b37ea18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31c9c02f43f1e6b778169bf5661082d4b6c8a35885806da725318c217b37ea18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31c9c02f43f1e6b778169bf5661082d4b6c8a35885806da725318c217b37ea18"
    sha256 cellar: :any_skip_relocation, ventura:        "1068bbbbb1a63fec1cf8a544fd0f4853500057333030dda506c3345d6858cb65"
    sha256 cellar: :any_skip_relocation, monterey:       "1068bbbbb1a63fec1cf8a544fd0f4853500057333030dda506c3345d6858cb65"
    sha256 cellar: :any_skip_relocation, big_sur:        "1068bbbbb1a63fec1cf8a544fd0f4853500057333030dda506c3345d6858cb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc9c6cb39612162468d91047345e30e88d3a786069c66a4145dbfdb86d863b71"
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
