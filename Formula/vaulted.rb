class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v3.0.0.tar.gz"
  sha256 "ea5183f285930ffa4014d54d4ed80ac8f7aa9afd1114e5fce6e65f2e9ed1af0c"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d0e8646d3798280b9fbb7aff4e09e888a97c71864f49301b15c793042f557c8" => :catalina
    sha256 "5b448f1ea890af2ec60633eb6aec8939be2893c7a134b748af5db26fb4926291" => :mojave
    sha256 "6cc74771b207de479c1f45e5385e7b55a46daa256377ec0098746d1e0d3a6441" => :high_sierra
    sha256 "b5a81beb6acdbb14c1d83304c2cf12c21b37a41c93dc48d11b588025f777ed68" => :sierra
  end

  depends_on "go" => :build

  def install
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
