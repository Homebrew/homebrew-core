class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.8.0.tar.gz"
  sha256 "7b4c65fae9cf9cb7ce70928fe6580fa9d077c425e1831958098ebc4537ae16c2"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4d2f9f3f517e26a008d70fa5d4f3e782ea036e836980765f1b33e665ed24bc1" => :high_sierra
    sha256 "b4d2f9f3f517e26a008d70fa5d4f3e782ea036e836980765f1b33e665ed24bc1" => :sierra
    sha256 "b4d2f9f3f517e26a008d70fa5d4f3e782ea036e836980765f1b33e665ed24bc1" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    system "go", "run", "build.go"
    bin.install "restic"
  end

  test do
    mkdir testpath/"restic_repo"
    ENV["RESTIC_REPOSITORY"] = testpath/"restic_repo"
    ENV["RESTIC_PASSWORD"] = "foo"

    (testpath/"testfile").write("This is a testfile")

    system "#{bin}/restic", "init"
    system "#{bin}/restic", "backup", "testfile"

    system "#{bin}/restic", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
