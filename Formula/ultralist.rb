class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.4.tar.gz"
  sha256 "fde0d3c7b1ba398944b01b55eddd16c2163d61c3c478528c4c36abd643fe76ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b1cdeef18209fcd4b3c45cfe91443416a9c21aa94b0b5125fc27716ae775c81" => :catalina
    sha256 "1a25d3fa74c7e6fbb282e605f0f8017f4e511e2a4a49dccfc3621aa515b2deee" => :mojave
    sha256 "78bc87822af37101d4697b1cafcfb1e089f5d4ab8b14bd850144ce16e971cd13" => :high_sierra
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
