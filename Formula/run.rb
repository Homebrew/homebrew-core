class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.11.2.tar.gz"
  sha256 "942427701caa99a9a3a6458a121b5c80b424752ea8701b26083841de5ae43ff6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2761a21abc5248ef96c4ce27d2a6ccb13a934628cb8558adfbf50231b294d51"
    sha256 cellar: :any_skip_relocation, ventura:        "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, monterey:       "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b439f95e50d7222492f98058be32dcbba251745fcb559847585f045b6818651"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4c0960a0cc0af7ae09ba1ee4cbc45d2f1703ee85319cf2b209f17103f16441"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
