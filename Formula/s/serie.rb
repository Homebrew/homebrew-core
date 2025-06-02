class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://github.com/lusingander/serie/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "a5d95b283c83f5efdf7d6a7faa66e9bfeec771924349edd7df80a1f0c631256b"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3313fbf0747b7dd4f69f35c45159e818b6afae30f6eb0e9ab9f18dd4ecc0a8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc7e38f3baca1f1d2b8bbda77c5324415d361064f4bda6de76745e546a8898cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65d8c5fc783a314a94ac9210561d6b2489a8185011b9ae71cc8d337aa0b2b1fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d637beacf49d78fe68dcddcf39c015e7e96b2f4d899385a4cc994fd8a5dfec"
    sha256 cellar: :any_skip_relocation, ventura:       "dc4470a6e21904043a64e752d11cc17fb4682dc27a1ad64b81b37411fbad4c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e43f9e97f1233da11a4a72582f8e06f63aa5998985fee083e1544942a99b290a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acca19320688d5560814dc0698332409dacc70e9a4d6a8456659bee6837c6f10"
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
