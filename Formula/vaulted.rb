class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v3.0.0.tar.gz"
  sha256 "ea5183f285930ffa4014d54d4ed80ac8f7aa9afd1114e5fce6e65f2e9ed1af0c"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e28a27d6d1c24b2cd7d3ca0ff147a8309425dcd1d405861378bd40c191af5d2" => :catalina
    sha256 "246a6e46d12ceb79f4406802a72860a4d4e381bf34b8228c10773898b33dbb3e" => :mojave
    sha256 "24f80eafb9d738391a99724915f07a546ebc822d5e3ab725fc90bfa690cc4ee7" => :high_sierra
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
