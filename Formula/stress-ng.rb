class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.14.03.tar.gz"
  sha256 "95012c62883ab5826e6157557a075df98cce3cbce2a48bb40851bcc968a8441a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd5be4e9de2817769fadc7ddda5049427f7a2e803c18a696fb43b970fb49dc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef247f9750dd248fe89255e7508bab64f488c6da5a74fa558f473b8649f4c54a"
    sha256 cellar: :any_skip_relocation, monterey:       "f1979202ebfcc1e497a2bdee96f058dfb7bbce4e238f583024be42e1d7e4e91b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c194ab72ab397c209b0dd9eae9266d681433927a9283cebc6c55994186f7a15e"
    sha256 cellar: :any_skip_relocation, catalina:       "c7694bcece3809234ae2152e900aaa1baf70ab5cc84975c9cc6478099f7eb9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d28bfdc77967c3136ae6c508a6c8366d9ecb133fc49e0792500fdb2b7e42653d"
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
