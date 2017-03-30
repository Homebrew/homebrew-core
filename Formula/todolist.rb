class Todolist < Formula
  desc "Very fast, simple task manager for the command-line, based upon GTD."
  homepage "http://todolist.site"
  url "https://github.com/gammons/todolist/archive/0.5.3.tar.gz"
  sha256 "468b8394e78185956c3d5603cd49780255151fb90ef1aec91ae978fd5cceba2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc96ecf1a3268e781b58f2462deb08a6d5d9fc87305cdd02f5ecbe867f778fc" => :sierra
    sha256 "0b90c2a287d260672545d80b74935db06492882222586d78dce6cbcbbd0e3263" => :el_capitan
    sha256 "48269538bfe340d38fd1215314b155941c24a80add35c0cd4d38bb44e3f92eca" => :yosemite
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gammons/").mkpath
    ln_s buildpath, buildpath/"src/github.com/gammons/todolist"
    system "go", "build", "-o", bin/"todolist", "./src/github.com/gammons/todolist"
  end

  test do
    system bin/"todolist", "init"
    assert File.exist?(".todos.json")
    add_task = shell_output("#{bin}/todolist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
