class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/v4.1.2.tar.gz"
  sha256 "8e5f623f9d58e08460d3ecabb28c53f1969bed09c2526f01b5e00362a8b08e7f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "83bd7d67371e37e898dc6c39f9ba17d118b24c974a85a8bfd281ceff63afed0f" => :catalina
    sha256 "baa7d0b87d9154caea44a01c94da1fa6159ab844c17eccada88ee877a48d0840" => :mojave
    sha256 "3eb95853dcd0c2eff2c14eec1f7d5c70344319d70bbbe257873601fe8b8e32c6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
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
