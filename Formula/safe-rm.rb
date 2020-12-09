class SafeRm < Formula
  desc "Wraps rm to prevent dangerous deletion of files"
  homepage "https://launchpad.net/safe-rm"
  url "https://launchpad.net/safe-rm/trunk/1.0.0/+download/safe-rm-1.0.0.tar.gz"
  sha256 "7258a1ed4518598cef4d478ed43ff5677023b897a8941585eddbdf63a56718f5"
  license "GPL-3.0-or-later"
  head "https://git.launchpad.net/safe-rm", using: :git

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2196591237f36b84a8f715907743e5da00bf8f47f8867734e9a2c048361717cf" => :big_sur
    sha256 "deccc20055e675864f7e13194eb720928b94f6e9799f1a83030db87f65dc645e" => :catalina
    sha256 "0c2d57ca73b19cf2fc2d29b38863ab570ac75db5678842099c032f383fad2be9" => :mojave
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
