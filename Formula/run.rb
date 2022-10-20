class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.9.1.tar.gz"
  sha256 "39aad9167c73101839749d27bd8c915bfd8e4a26ed21d729981b646c2c171ebf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8991c3a51e0bd5aef35d77e669e18851a2fac7be0c63f618b3aed083a02639d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8991c3a51e0bd5aef35d77e669e18851a2fac7be0c63f618b3aed083a02639d6"
    sha256 cellar: :any_skip_relocation, monterey:       "61e354516082cc6f66c33b1161756960ec1e122799c82702aacef71007f0da30"
    sha256 cellar: :any_skip_relocation, big_sur:        "61e354516082cc6f66c33b1161756960ec1e122799c82702aacef71007f0da30"
    sha256 cellar: :any_skip_relocation, catalina:       "61e354516082cc6f66c33b1161756960ec1e122799c82702aacef71007f0da30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "297ad30a6df942e0020a7ceeb6a7766f4f6347bf789c93f9d9132394bb1552b6"
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
