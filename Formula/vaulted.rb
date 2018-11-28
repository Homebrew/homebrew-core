class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.3.0.tar.gz"
  sha256 "8e4f56007591fe1a6abcaf77c63ebf99d346f3191b5306fd53d3292081330eed"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41f696160fa092b0d80d6d4d267ff05f5fa10bdbb43ab2984bfb4ed93ded0540" => :mojave
    sha256 "db68eee1cf7831a4fcd07b446b1ec9e4e31f61180e43dc78d5609974d233bb89" => :high_sierra
    sha256 "f26213f97d628b3fd09da3499599ce809836d35a8d9066c4ca0956337e8004e2" => :sierra
    sha256 "d6cb9dee20339fe668adcf97447a6451f59e970ccef032cb97665582fa064ce4" => :el_capitan
    sha256 "643939ca33c34a15ac264bf4cb66aaf1b14fb175528b40ab2fbaa206baa62624" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    system "go", "build", "-o", bin/"vaulted", "."
    man1.install Dir["doc/man/vaulted*.1"]
  end

  test do
    (testpath/".local/share/vaulted").mkpath
    touch(".local/share/vaulted/test_vault")
    output = IO.popen(["#{bin}/vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end
