class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.11.0.tar.gz"
  sha256 "f9ea93feb1231674c2b8ec1d52b72c3f2ca0cd4590d09b9b39356a97dbf4a920"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "064ba836c8f0c5bf55687f32a31a5c3ca2697a35ee179fb0008ee2088852ad01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "064ba836c8f0c5bf55687f32a31a5c3ca2697a35ee179fb0008ee2088852ad01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "064ba836c8f0c5bf55687f32a31a5c3ca2697a35ee179fb0008ee2088852ad01"
    sha256 cellar: :any_skip_relocation, ventura:        "35befd6adc7d143999df865c38b28c4794e59d8ce211a7ed2259ef5e394f215d"
    sha256 cellar: :any_skip_relocation, monterey:       "35befd6adc7d143999df865c38b28c4794e59d8ce211a7ed2259ef5e394f215d"
    sha256 cellar: :any_skip_relocation, big_sur:        "35befd6adc7d143999df865c38b28c4794e59d8ce211a7ed2259ef5e394f215d"
    sha256 cellar: :any_skip_relocation, catalina:       "35befd6adc7d143999df865c38b28c4794e59d8ce211a7ed2259ef5e394f215d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3049d3110bddcfb68a6e609923d8f71b3b631ec812b3996cf9490fe08b9a91ee"
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
