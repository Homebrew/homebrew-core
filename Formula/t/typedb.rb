class Typedb < Formula
  desc "Strongly-typed database with a rich and logical type system"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.22.0/typedb-all-mac-2.22.0.zip"
  sha256 "fb00290061e8be06a0d5f50e1cca7eb9ee3bcfca4c7d1013c207e087d35a1ec1"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "341c622c7556708339848af7eecbfe9de4281da230152602363cc012679d8b0f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    mkdir_p var/"typedb/data"
    inreplace libexec/"server/conf/config.yml", "server/data", var/"typedb/data"
    mkdir_p var/"typedb/logs"
    inreplace libexec/"server/conf/config.yml", "server/logs", var/"typedb/logs"
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env)
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server --help")
  end
end
