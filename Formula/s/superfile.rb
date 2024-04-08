class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/MHNightCat/superfile"
  url "https://github.com/MHNightCat/superfile/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "140ee260c515090c1b540b34e56d8836a84fccdd3232132312b3ebbb06ae537f"
  depends_on "go" => :build
  depends_on "exiftool"

  def install
    Dir.chdir "src" do
      system "go", "build", "-o", "../bin/spf"
    end
    bin.install Dir["bin/*"]
  end

  test do
    output = shell_output("#{bin}/spf -v")
    assert_match("superfile version v1.0.1", output)
  end
end
