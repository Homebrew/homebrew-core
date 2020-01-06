class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.4.tar.gz"
  sha256 "fde0d3c7b1ba398944b01b55eddd16c2163d61c3c478528c4c36abd643fe76ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "7817cf565464c09bbdae680d0849f59105b5388806ec1c73d0551c697f0c4b3f" => :catalina
    sha256 "7546817405dc0d2e1c87efdef031b3cbdca8d1399fe5fac4eea8cba4c0c1699f" => :mojave
    sha256 "b07adf0017cf56922b16c8529561a8cebbd23605a8c06f9415d7744cdccabf7e" => :high_sierra
    sha256 "e19e911af109a6b04d04f37390a7fb4922ee4e2c571a7a1db5b7a335b13db5b0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ultralist/").mkpath
    ln_s buildpath, buildpath/"src/github.com/ultralist/ultralist"
    system "go", "build", "-o", bin/"ultralist", "./src/github.com/ultralist/ultralist"
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
