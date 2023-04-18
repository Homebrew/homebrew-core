class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.15.07.tar.gz"
  sha256 "7ad1f30237011149e7f83451ea7cb49e88c0a79bed55e29b556c6a72b9f1d79d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c9ad6aa649118bdfcd376a7348a1fef406ff6ff17159d53b2101bc6fd201bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7f9487fed4538ed0bfe4d8b7cf7b15e566e951ab1f8b3759e1c22f834ad21b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a08288aad4ac684f8161f06ff21b7d1c7be744b3e6eeacb481b034be168c06c0"
    sha256 cellar: :any_skip_relocation, ventura:        "770bbd2fb88b037305754efcad54375b85fa47ca66a240b70bbedc0eac523611"
    sha256 cellar: :any_skip_relocation, monterey:       "c2ba8b414504025bba674b5c30df6e3743e2bcab55caf131c4c33c276875ff7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5ae577e1d5220316cc4008fac1f665a4b4792e06ffc7be2a24c0f4cf5e92e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "335c7491eaa431f94600c17c931e98b4480c5e1330080c0f032ac6cb7bd876b3"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
