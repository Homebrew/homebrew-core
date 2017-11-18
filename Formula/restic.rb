class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.7.3.tar.gz"
  sha256 "6d795a5f052b3a8cb8e7571629da14f00e92035b7174eb20e32fd1440f68aaff"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcaf988b191c6d859a77fd670f88e3d866cb7e5df07d098367a3d65520b27221" => :high_sierra
    sha256 "fcaf988b191c6d859a77fd670f88e3d866cb7e5df07d098367a3d65520b27221" => :sierra
    sha256 "fcaf988b191c6d859a77fd670f88e3d866cb7e5df07d098367a3d65520b27221" => :el_capitan
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
