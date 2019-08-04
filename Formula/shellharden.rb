class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.1.1.tar.gz"
  sha256 "7d7ac3443f35eb74abfc78fa67db2947d60b7d0782f225f55d6eefafcf294c7c"

  bottle do
    sha256 "23a4338547c6cb9b3e4e8d454cb8e1420c5a38f0440b9dde0f95384656ef87ca" => :mojave
    sha256 "1dc1515f934b43e17b4faeb17cda61a22a28866e625d863c7372eda6a2e111d3" => :high_sierra
    sha256 "2fdb7e3d8fdeab4089143e5d11f1b5b379f25b11623af5497cd54e829ccd1b85" => :sierra
    sha256 "d1b2430ab2de01134b5a0b4435fb7280bed7f140e662d7e2ccd4764a5be6e737" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
