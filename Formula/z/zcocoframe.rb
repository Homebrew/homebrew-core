class Zcocoframe < Formula
    desc "CLI tool to generate xcframeworks easily"
    homepage "https://github.com/hariTH-0828/zcocoframe"
    url "https://github.com/hariTH-0828/zcocoframe/archive/refs/tags/V1.0.0.tar.gz"
    sha256 "784eb055ae197b4cc69cc9a97c9fdc7022adb0d08747a6ad5a4b21d4f0d123c3"
    license "MIT"
  
    def install
      # First, make the script executable
      chmod "+x", "zcocoframe.sh"
      # Then install it
      bin.install "zcocoframe.sh" => "zcocoframe"
    end
    
    test do
      system "#{bin}/zcocoframe", "--version"
    end
end