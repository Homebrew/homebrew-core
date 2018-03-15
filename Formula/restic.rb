class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.8.3.tar.gz"
  sha256 "0cf697c88404b180d6d6ff2e7d2c27b2fcb9536da6dbdf15ad4d320af7e8f17c"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93fa732cd990a24769b710a12240735004f8d48646cecfd34c808667e73f883c" => :high_sierra
    sha256 "9ce2907424db4dad23dd2042b14d14a5408c9e82fe82a4be51c155e6b385efd7" => :sierra
    sha256 "bd4e53c98f85cd63735b07c2ea203790b82447152e548f7b27e5961236c6752b" => :el_capitan
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
