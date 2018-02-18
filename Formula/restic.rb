class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.8.2.tar.gz"
  sha256 "0c19de7f525b4f40bf35347c9834564e48cdfdf1b64972d0aef9e548d29960dd"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c61814277f7c056345ab09256c0ed3ea24869d582aa859c3b5069a79bd811a4" => :high_sierra
    sha256 "550e140e3f97b0d9f1b235f88b1bb16bbd1ffc9be808967f77a8ef1a9e969fa6" => :sierra
    sha256 "9aef476bb1281133e064ded5b2164b68f215c17335ade312c7dcab0795752eab" => :el_capitan
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
