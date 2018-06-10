class Restic < Formula
  desc "Fast, efficient and secure backup program"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.9.1.tar.gz"
  sha256 "359d3b8e555a9952f2b98c81ee3dbec8dc441e12789c436ca564762aaacec095"
  head "https://github.com/restic/restic.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6017af9f49c661ab29ab8eef9a2e9b77fa388c2cd65d6c1fd22abdd7599987b5" => :high_sierra
    sha256 "89806d8bd480250d09c83cf6dfcb2b7579ed0e46bcb24b01517e3aa9ec80bec8" => :sierra
    sha256 "795ec6c48f37e64464d40f4b25edd844568f65549dcd1f93f39d283fca36dbfd" => :el_capitan
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
