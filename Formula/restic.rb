class Restic < Formula
  desc "Backups done right"
  homepage "https://restic.github.io/"
  url "https://github.com/restic/restic/archive/v0.7.3.tar.gz"
  sha256 "6d795a5f052b3a8cb8e7571629da14f00e92035b7174eb20e32fd1440f68aaff"
  head "https://github.com/restic/restic.git"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "restic"
  end

  test do
    system "RESTIC_PASSWORD=foo", "#{bin}/restic", "-r", ".",  "init"
    system "RESTIC_PASSWORD=foo", "#{bin}/restic", "-r", ".",  "backup", #{$0}"

    snapshot = shell_output("RESTIC_PASSWORD=foo #{bin}/restic -r . snapshots") | tail -n+3 | head -n1 | awk '{print $1}'`
    snapshot.chomp!

    system "RESTIC_PASSWORD=foo restic -r #{test_repo_path} restore #{snapshot} -t #{test_repo_path}-restore"
    system "diff -q #{$0} #{test_repo_path}-restore/#{File.basename($0)}"
  end
end
