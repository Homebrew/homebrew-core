class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ae37fe7e52ade753f850ab81c7d5344f8e540ab6886f877bf5b613620c909893"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b559e27a6e0ba6aa3a9e576306c5de4c7623df4e66fe22b23d8b064a785cba75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62e58ee735695f64fff35b0c32c1ddda7688d7da3c970652e3118ec8843394be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e58ee735695f64fff35b0c32c1ddda7688d7da3c970652e3118ec8843394be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62e58ee735695f64fff35b0c32c1ddda7688d7da3c970652e3118ec8843394be"
    sha256 cellar: :any_skip_relocation, sonoma:        "555c4a74bb2df5b11488b54589a7b8b4cea5bcddba87ad9c1bf04a2054ffa154"
    sha256 cellar: :any_skip_relocation, ventura:       "555c4a74bb2df5b11488b54589a7b8b4cea5bcddba87ad9c1bf04a2054ffa154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f740a33f47dd36334f738d3e737470af49606c175729525b1436dae5ea5f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f1fe18a37fa617a10925711ff8d2c00ea7f61a9030537d478b2df88fe3aec46"
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
    (testpath/"test.tape").write <<~TAPE
      Output test.gif
      Type "Foo Bar"
      Enter
      Sleep 1s
    TAPE

    system bin/"vhs", "validate", "test.tape"

    assert_match version.to_s, shell_output("#{bin}/vhs --version")
  end
end
