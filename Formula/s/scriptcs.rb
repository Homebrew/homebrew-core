class Scriptcs < Formula
  desc "Tools to write and execute C#"
  homepage "https://github.com/scriptcs/scriptcs"
  url "https://github.com/scriptcs/scriptcs/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "e876118d82f52cbdd9569783ec9278c4ac449055aa628cdcb2d785bf8098a434"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d25a27968072aa23232a11aceed62f1f8edcbdbe31ac2637cdd5becba69bed6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5187aaee21aced8951a79b8a23c8e9a870ce5e17da5d15837add0aeadb3f5dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "03ca8a3a21a88d12cafcf11b79527899caa5545056b4d0d77998b137206cc5f6"
    sha256 cellar: :any_skip_relocation, ventura:        "507936c0cd4b26dd49508ebf8725b1d9356a611d958a93da0a024e98632b5484"
    sha256 cellar: :any_skip_relocation, monterey:       "630be0cd09a3dc16e8c7404875adfe89d009ce9a73f6d5dcae9700253a3c110c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9153f24a59a73f78f74915a8e1d8de488ec016deb1aac1825774e19d6420545d"
    sha256 cellar: :any_skip_relocation, catalina:       "c14c80f7b24ac5f2c14119ec2f371416ae07b9fba8bd9b0eb90d57ef5104f765"
    sha256 cellar: :any_skip_relocation, mojave:         "121137df4078b2819a16f0f3e75924b10eba51a3ca7ac0a4be3d9010d2d1f7aa"
    sha256 cellar: :any_skip_relocation, high_sierra:    "263fda7addb857a9ed3c0c15856c422d3684ad069c2efc644858bb1779a92e91"
    sha256 cellar: :any_skip_relocation, sierra:         "9ccece2f779060ab23e699b07d6cc6ce0b2c2e0058cc995b1541e1170f69a6eb"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e3b6cb117d23ccf9a745e0ac5e61fcb531d7e8a08476699d2ece6c31e564450e"
  end

  # https://github.com/scriptcs/scriptcs/issues/1323
  disable! date: "2024-02-12", because: :unmaintained

  depends_on "mono"

  def install
    script_file = "scriptcs.sh"
    system "sh", "./build_brew.sh"
    libexec.install Dir["src/ScriptCs/bin/Release/*"]
    (libexec/script_file).write <<~EOS
      #!/bin/bash
      mono #{libexec}/scriptcs.exe $@
    EOS
    (libexec/script_file).chmod 0755
    bin.install_symlink libexec/script_file => "scriptcs"
  end

  test do
    test_file = "tests.csx"
    (testpath/test_file).write('Console.WriteLine("{0}, {1}!", "Hello", "world");')
    assert_equal "Hello, world!", `scriptcs #{test_file}`.strip
  end
end
