class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.8.1.tar.gz"
  sha256 "1e0e0d1e7388beaa2a892c057759fdfe6a4fe915f9518c73068761f8d6d7619d"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "111b944bbb5dc7811694bc94ee7d40ce1a9009612aa99841594e28b6e35a58af" => :high_sierra
    sha256 "111b944bbb5dc7811694bc94ee7d40ce1a9009612aa99841594e28b6e35a58af" => :sierra
    sha256 "111b944bbb5dc7811694bc94ee7d40ce1a9009612aa99841594e28b6e35a58af" => :el_capitan
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
