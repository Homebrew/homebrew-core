class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "703ab37f1bb994e7decc0b48200dd82b24e58ddff8d3204d9cb53fed67ef0f4a"
  license "MIT"
  depends_on "go" => :build

  def install
    Dir.chdir "src" do
      system "go", "build", "-o", "../bin/spf"
    end
    bin.install Dir["bin/*"]
  end

  test do
    output = shell_output("#{bin}/spf -v")
    assert_match("superfile version v1.1.0", output)
  end
end
