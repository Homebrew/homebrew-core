class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https://github.com/miquella/vaulted"
  url "https://github.com/miquella/vaulted/archive/v2.4.0.tar.gz"
  sha256 "ff29e705ee4bada70c6ce4f8a943dca71e9a3acd4390fcd9c9739b1c06b99411"
  head "https://github.com/miquella/vaulted.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a16cebc3c61049267dd44d486a3735fbe8e349fcbc8474954b9f9cfbb0389890" => :mojave
    sha256 "3320d39ed310b8dea78f5b632b92b5a8c27096103010781ea580d5d9acb84a49" => :high_sierra
    sha256 "ec7c5caa96c6d0f962f74115bf0adebf68fd670b657cdaddb77fc4a8d45c2081" => :sierra
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
