class RealpathOsx < Formula
  desc "Minimal implementation of realpath for Mac OS X"
  homepage "https://github.com/harto/realpath-osx"
  url "https://github.com/harto/realpath-osx/archive/1.0.0.tar.gz"
  sha256 "ba0ff6ef5647c83b67f06bab4825759099995a09321af609e18812b030406de8"
  head "https://github.com/harto/realpath-osx.git"

  conflicts_with "coreutils", :because => "both install a `realpath` binary"

  def install
    system "make"
    bin.install "realpath"
  end

  test do
    ln_s "/bin/ls", testpath
    output = shell_output("#{bin}/realpath #{testpath}/ls").chomp
    assert_equal "/bin/ls", output
  end
end
