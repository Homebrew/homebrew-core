class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.4.0.tar.gz"
  sha256 "ff29e705ee4bada70c6ce4f8a943dca71e9a3acd4390fcd9c9739b1c06b99411"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "da19f0ae3296cd695dced87aa93828c96754570427842880a286397d5de30c50" => :mojave
    sha256 "5c027f23bd0a0d9b30a8392ad40e86a72ea57700d4a8a8a16d51973085b2d6b5" => :high_sierra
    sha256 "e81be3ea83b9716e53e9e981aa87da08a9bfcc8555f11eaf602fd6e36b56beae" => :sierra
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
