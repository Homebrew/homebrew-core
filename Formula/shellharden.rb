class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v3.1.tar.gz"
  sha256 "293ef20ea4ecb6927f873591bb6d452979ebc31af80fdad48c173816b4ae6c6f"

  bottle do
    sha256 "86bda4e6431157ac10a6232ea15f48c0b7ad567ac378d93d97879286937bae3e" => :high_sierra
    sha256 "03c738230eae54cf6694b1a789911700713e6a2b87e015e79aee0c527cd9c504" => :sierra
    sha256 "cea6436d0f7d4c7d58c18a5a6f4a3c2aafb8d889725ec2bdeecff4a6d585da6a" => :el_capitan
  end

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
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
