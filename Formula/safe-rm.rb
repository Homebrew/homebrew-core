class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/1.0.0/+download/safe-rm-1.0.0.tar.gz"
  sha256 "7258a1ed4518598cef4d478ed43ff5677023b897a8941585eddbdf63a56718f5"
  license "GPL-3.0-or-later"
  head "https://git.launchpad.net/safe-rm"

  livecheck do
    url :stable
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
