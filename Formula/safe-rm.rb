class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/0.13/+download/safe-rm-0.13.tar.gz"
  sha256 "f0f792faa076fbf3dbffbb4bc8918fd6bf699775417fef3f5f408f0c69200c12"
  license "GPL-3.0-or-later"
  head "https://git.launchpad.net/safe-rm"

  livecheck do
    url :stable
  end

  bottle :unneeded

  def install
    bin.install "safe-rm"
  end

  test do
    foo = testpath/"foo"
    bar = testpath/"bar"
    (testpath/".config").mkdir
    (testpath/".config/safe-rm").write bar
    touch foo
    touch bar
    system "#{bin}/safe-rm", foo
    refute_predicate foo, :exist?
    shell_output("#{bin}/safe-rm #{bar} 2>&1", 64)
    assert_predicate bar, :exist?
  end
end
