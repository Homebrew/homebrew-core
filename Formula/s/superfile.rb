class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3d32b838aab524a3d2b93a58bd211d1f159d742e6eb486003f6d111d4f8dfdbd"
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
