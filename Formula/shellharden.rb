class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.0.tar.gz"
  sha256 "91660e4908bd07105f091a62e6f77bc9ed42045096b38abe31503cd2609cb7a0"

  bottle do
    sha256 "247faad7689b5f46f3fedb9263c8b165ff557e4ae1d5063c969ac38a11d92721" => :high_sierra
    sha256 "823ff667956ce5b7e3484ff65fa112d9a81bb58bd90a4b22c47103abfc9f8c9b" => :sierra
    sha256 "ef39962f0ba91f0fa40d49b20263e17e2bdc3d22b06c565c45dc8e95e8b76c70" => :el_capitan
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
