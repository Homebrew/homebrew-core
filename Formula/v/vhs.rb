class Vhs < Formula
  desc "Your CLI home video recorder"
  homepage "https://github.com/charmbracelet/vhs"
  url "https://github.com/charmbracelet/vhs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "ae37fe7e52ade753f850ab81c7d5344f8e540ab6886f877bf5b613620c909893"
  license "MIT"
  head "https://github.com/charmbracelet/vhs.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc042cfbdee07dea3f8c861cb000601322597f7ac7486c333f10d5de8ef21cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc042cfbdee07dea3f8c861cb000601322597f7ac7486c333f10d5de8ef21cde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc042cfbdee07dea3f8c861cb000601322597f7ac7486c333f10d5de8ef21cde"
    sha256 cellar: :any_skip_relocation, sonoma:        "15bfbc955ca5dc09d33141d3994e639b76aec988a7eea564041e01c1fb121e5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5105b1a3316e949465fbbd7f1840d721c5e84b5aa8698cc5a2184c3157fdedf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1d30de9afd56023e000a52794944b76d746544e681da39905811384c60dce97"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    (man1/"vhs.1").write Utils.safe_popen_read(bin/"vhs", "man")

    generate_completions_from_executable(bin/"vhs", shell_parameter_format: :cobra)
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
