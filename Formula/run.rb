class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.9.1.tar.gz"
  sha256 "39aad9167c73101839749d27bd8c915bfd8e4a26ed21d729981b646c2c171ebf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8048f0c0b0672b58f87c1f62d82902cf2040436591f3fc69f0ca50f60c5257e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8048f0c0b0672b58f87c1f62d82902cf2040436591f3fc69f0ca50f60c5257e1"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe61559884892ff9ac980ef6002d13ee1edc54de63045845dfd8532a81377a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe61559884892ff9ac980ef6002d13ee1edc54de63045845dfd8532a81377a4"
    sha256 cellar: :any_skip_relocation, catalina:       "8fe61559884892ff9ac980ef6002d13ee1edc54de63045845dfd8532a81377a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5a91284adc9fb7d1a2b67cd30dc365f37ef420b1f53e050426f7fe3a3a1f038"
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
