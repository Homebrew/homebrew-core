class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v3.1.tar.gz"
  sha256 "293ef20ea4ecb6927f873591bb6d452979ebc31af80fdad48c173816b4ae6c6f"

  depends_on "rust" => :build

  def install
    # NOTE: This uses Cargo to build from the next release.
    system "rustc", "shellharden.rs"
    bin.install "shellharden"
  end

  test do
    (testpath/"script.sh").write <<~EOS
      dog="poodle"
      echo $dog
    EOS
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", File.read(testpath/"script.sh")
  end
end
