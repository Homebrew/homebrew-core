class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.0.tar.gz"
  sha256 "91660e4908bd07105f091a62e6f77bc9ed42045096b38abe31503cd2609cb7a0"

  bottle do
    sha256 "be7dc7deabe3b7e091ece936f60aaa6df4537eba0072d3684e0b19029bbb220f" => :high_sierra
    sha256 "d156e635f675b7adb256053242efc1d9e5a0c13fa773753eb9effbbd258ccde7" => :sierra
    sha256 "b084b254133558dbba9aa03e0f7a839d65c2ce84961c3782b848845b21cdd449" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
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
