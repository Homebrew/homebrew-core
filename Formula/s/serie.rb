class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "32ea162b9aece1e65e4d813063447004b77b27c85304a4122bb63b16f38389ea"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9cbaf142fc79d12a4d69fca2fb2ed3d5629e0bac1acbefdf4b3d27954e45027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b173059e87b60cf2e4ef204538450e2e4df98d1a3d2e8f0170854a388d747f13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2573a342ec084d75fef580a7ce2a7c1a26538dc331715426186f4524cd26bcc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f903acd198b13976ae7892e4d505b36e15de8dd0599aa658349888c7eb732212"
    sha256 cellar: :any_skip_relocation, ventura:       "184e82cc5aef27f8d30b6e8443ac05c5be04cffc48bd45f9cdf409a57318f30d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84c785cedcd18916c3b50f116f5f96e8a4d013aecc379961c5861b2a695b353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe031a7cf7a66532d21ecf94cfdd3fce534607c0645d24ef799664d8e2b5ca6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
