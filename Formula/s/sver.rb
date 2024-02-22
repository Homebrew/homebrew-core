class Sver < Formula
  desc "Semver (Semantic Version) parsing & utility script/function library in pure bash"
  homepage "https://github.com/robzr/sver"
  url "https://github.com/robzr/sver/releases/download/v1.0.0/sver"
  sha256 "a5571a9bac577819943fb72c23ce7a9989f8e61b39f68522b5625dba4586b77a"
  license "CC-BY-SA-3.0"

  def install
    bin.install "sver"
  end

  test do
    assert_match "v1.0.0", shell_output("#{bin}/sver version")
  end
end
