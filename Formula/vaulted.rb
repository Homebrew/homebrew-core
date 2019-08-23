class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.4.1.tar.gz"
  sha256 "babb2d076476ba477d545da1291918bb73e96668409c9b966c28ad20890c0eb9"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b448f1ea890af2ec60633eb6aec8939be2893c7a134b748af5db26fb4926291" => :mojave
    sha256 "6cc74771b207de479c1f45e5385e7b55a46daa256377ec0098746d1e0d3a6441" => :high_sierra
    sha256 "b5a81beb6acdbb14c1d83304c2cf12c21b37a41c93dc48d11b588025f777ed68" => :sierra
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
