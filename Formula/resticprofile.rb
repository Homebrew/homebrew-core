class Resticprofile < Formula
  desc "Configuration profiles for restic backup"
  homepage "https://github.com/creativeprojects/resticprofile"
  url "https://github.com/creativeprojects/resticprofile.git",
      tag:      "v0.13.1",
      revision: "d64dc4f77bae0f07f51c2dc76d7c820e2c415dda"
  license "GPL-3.0-only"
  head "https://github.com/creativeprojects/resticprofile.git"

  depends_on "go" => :build

  depends_on "restic"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{Time.now.utc.rfc3339}
      -X main.builtBy=homebrew
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags
  end

  test do
    assert_match "resticprofile version #{version}", shell_output("#{bin}/resticprofile version")

    (testpath/"restic_repo").mkdir
    (testpath/"password.txt").write("key")
    (testpath/"profiles.yaml").write <<~EOS
      default:
        repository: "local:#{testpath}/restic_repo"
        password-file: "password.txt"
        initialize: true
    EOS

    (testpath/"testfile").write("This is a testfile")

    system "#{bin}/resticprofile", "backup", "testfile"
    system "#{bin}/resticprofile", "restore", "latest", "-t", "#{testpath}/restore"
    assert compare_file "testfile", "#{testpath}/restore/testfile"
  end
end
