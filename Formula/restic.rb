class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.7.3.tar.gz"
  sha256 "6d795a5f052b3a8cb8e7571629da14f00e92035b7174eb20e32fd1440f68aaff"
  head "https://github.com/restic/restic.git"

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
