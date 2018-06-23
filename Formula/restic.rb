class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.1.tar.gz"
  sha256 "359d3b8e555a9952f2b98c81ee3dbec8dc441e12789c436ca564762aaacec095"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b40713df09aaf7bdd279882ded7a4ebdbfe23858c2449e2e22b9b02f73c8257a" => :high_sierra
    sha256 "38a643ada5131fdc41ad404205c8d7859cf31ec4fda34c1a72325ce3c866b186" => :sierra
    sha256 "585ccdbe4b1ec107e5e313104e3aa4863b27e4815b26fc862137577958dfbf10" => :el_capitan
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
