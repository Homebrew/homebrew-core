class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.3.tar.gz"
  sha256 "b95a258099aee9a56e620ccebcecabc246ee7f8390e3937ccedadd609c6d2dd0"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a048dc168233c08294adcc61b78db0543dbbf2e1a0067e78f8988c32435e169a" => :mojave
    sha256 "f223541a4d3567fc95f9b44413f7cf9170b396f431b10433a8f7827b854955a3" => :high_sierra
    sha256 "bf6074d53fe90a37c27c0ca19d63a482c157eada58f047fea0ed3d674b69dd90" => :sierra
    sha256 "b030816d6f9b924585bedbc014fde1e45748aadb935e3f4eb9bc46802e1dfc32" => :el_capitan
  end

  depends_on "go" => :build

  def install
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
