class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.7.2.tar.gz"
  sha256 "c542b523c67e3cd2ca05a8e2f92cca607181a68518b2568a68b76ed9f700d6e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84789be3bcac6e3f36e94aa168e49b01e3aeb93e8f5ecc80975c6032b61a96ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32fff2fd9c8b242912438be13118185afaa20bccad7bb134788ffcc07b66791d"
    sha256 cellar: :any_skip_relocation, monterey:       "7cc95b0e7a529a4c6b27e0fd0d021343faed6a57e0e4be8800f290fddb829ba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0beed1b3bd5d70f9a8a270a7996d0f309f2cab7cf622556b5d833f8311b8cf7a"
    sha256 cellar: :any_skip_relocation, catalina:       "4a2329ae36f59ed71c1b6364828c465a27f92506cd77e9a7c8217def3e2b7c9e"
    sha256 cellar: :any_skip_relocation, mojave:         "4a2329ae36f59ed71c1b6364828c465a27f92506cd77e9a7c8217def3e2b7c9e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "4a2329ae36f59ed71c1b6364828c465a27f92506cd77e9a7c8217def3e2b7c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a053c6c53ea13bf3b062d0423120886b30716341a230966dd45e8eb1d0b769da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
