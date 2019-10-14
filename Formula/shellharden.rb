class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.1.1.tar.gz"
  sha256 "7d7ac3443f35eb74abfc78fa67db2947d60b7d0782f225f55d6eefafcf294c7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d3933bd529531a8d9060b49a68b99e08820dd1a9952f7cc046aafdb4ebc49d0" => :catalina
    sha256 "edca629536f1b38bfb473dd98b2259726dba51fc448ea4e59e7a15359bc99fc3" => :mojave
    sha256 "41e43c80d63fe7a33d3d9f06741db902c0ab6fc26ed9bc5037f30295d43c8360" => :high_sierra
    sha256 "78a7c2a75348c1746c0d658b6e1070a4277934d534137642caf84871ac467596" => :sierra
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
